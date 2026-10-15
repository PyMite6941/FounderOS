import json
import os
import sqlite3
import uuid
from contextlib import contextmanager
from datetime import datetime, timezone
from functools import lru_cache
from pathlib import Path
from typing import Iterator


def _mongo_uri() -> str | None:
    for key in ("MONGODB_URI", "MONGO_URI"):
        value = os.environ.get(key, "").strip()
        if value:
            return value
    return None


@lru_cache(maxsize=2)
def _mongo_client(uri: str):
    from pymongo import MongoClient

    return MongoClient(uri, connectTimeoutMS=10_000, serverSelectionTimeoutMS=5_000)


def _mongo_database():
    uri = _mongo_uri()
    if not uri:
        return None

    client = _mongo_client(uri)
    configured_name = os.environ.get("MONGODB_DATABASE", "").strip()
    return client[configured_name] if configured_name else client.get_default_database("founderos")


def _database_path() -> Path:
    configured_path = os.environ.get("DATABASE_PATH")
    if configured_path:
        return Path(configured_path)
    return Path(__file__).resolve().parents[1] / "data" / "founderos.sqlite3"


@contextmanager
def _sqlite_connection() -> Iterator[sqlite3.Connection]:
    database_path = _database_path()
    database_path.parent.mkdir(parents=True, exist_ok=True)
    connection = sqlite3.connect(database_path, timeout=15)
    connection.row_factory = sqlite3.Row
    try:
        connection.execute(
            """
            CREATE TABLE IF NOT EXISTS saved_ideas (
                id TEXT PRIMARY KEY,
                user_id TEXT NOT NULL,
                idea TEXT NOT NULL,
                analysis_json TEXT NOT NULL,
                created_at TEXT NOT NULL
            )
            """
        )
        connection.execute(
            "CREATE INDEX IF NOT EXISTS saved_ideas_user_created "
            "ON saved_ideas (user_id, created_at DESC)"
        )
        connection.execute(
            """
            CREATE TABLE IF NOT EXISTS conversation_messages (
                message_id TEXT PRIMARY KEY,
                conversation_id TEXT NOT NULL,
                user_id TEXT,
                client TEXT NOT NULL,
                role TEXT NOT NULL CHECK (role IN ('user', 'assistant')),
                content TEXT NOT NULL,
                sequence INTEGER NOT NULL,
                created_at TEXT NOT NULL,
                UNIQUE (conversation_id, sequence)
            )
            """
        )
        connection.execute(
            "CREATE INDEX IF NOT EXISTS conversation_messages_owner_created "
            "ON conversation_messages (user_id, created_at DESC)"
        )
        yield connection
        connection.commit()
    except Exception:
        connection.rollback()
        raise
    finally:
        connection.close()


def _timestamp_string(timestamp: datetime | str) -> str:
    return timestamp.isoformat() if isinstance(timestamp, datetime) else timestamp


def save_idea(user_id: str, idea: str, analysis: dict) -> dict:
    created_at = datetime.now(timezone.utc)
    database = _mongo_database()
    if database is not None:
        database.saved_ideas.insert_one(
            {
                "_id": analysis["id"],
                "userId": user_id,
                "idea": idea,
                "analysis": analysis,
                "createdAt": created_at,
            }
        )
    else:
        with _sqlite_connection() as connection:
            connection.execute(
                """
                INSERT INTO saved_ideas (id, user_id, idea, analysis_json, created_at)
                VALUES (?, ?, ?, ?, ?)
                """,
                (
                    analysis["id"],
                    user_id,
                    idea,
                    json.dumps(analysis, ensure_ascii=False),
                    created_at.isoformat(),
                ),
            )
    return {
        "id": analysis["id"],
        "idea": idea,
        "analysis": analysis,
        "createdAt": created_at.isoformat(),
    }


def list_ideas(user_id: str) -> list[dict]:
    database = _mongo_database()
    if database is not None:
        documents = database.saved_ideas.find({"userId": user_id}).sort(
            [("createdAt", -1), ("_id", -1)]
        )
        return [
            {
                "id": document["_id"],
                "idea": document["idea"],
                "analysis": document["analysis"],
                "createdAt": _timestamp_string(document["createdAt"]),
            }
            for document in documents
        ]

    with _sqlite_connection() as connection:
        rows = connection.execute(
            """
            SELECT id, idea, analysis_json, created_at
            FROM saved_ideas
            WHERE user_id = ?
            ORDER BY created_at DESC, id DESC
            """,
            (user_id,),
        ).fetchall()
    return [
        {
            "id": row["id"],
            "idea": row["idea"],
            "analysis": json.loads(row["analysis_json"]),
            "createdAt": row["created_at"],
        }
        for row in rows
    ]


def delete_idea(user_id: str, idea_id: str) -> bool:
    database = _mongo_database()
    if database is not None:
        result = database.saved_ideas.delete_one({"_id": idea_id, "userId": user_id})
        return result.deleted_count > 0

    with _sqlite_connection() as connection:
        cursor = connection.execute(
            "DELETE FROM saved_ideas WHERE id = ? AND user_id = ?",
            (idea_id, user_id),
        )
    return cursor.rowcount > 0


def save_analysis_messages(
    user_id: str | None,
    client: str,
    idea: str,
    analysis: dict,
) -> str:
    conversation_id = analysis["id"]
    created_at = datetime.now(timezone.utc)
    assistant_content = json.dumps(analysis, ensure_ascii=False)
    database = _mongo_database()
    messages = [
        {"role": "user", "content": idea, "sequence": 0},
        {"role": "assistant", "content": assistant_content, "sequence": 1},
    ]

    if database is not None:
        database.conversations.insert_one(
            {
                "_id": conversation_id,
                "conversationId": conversation_id,
                "userId": user_id,
                "client": client,
                "messages": messages,
                "createdAt": created_at,
            }
        )
        return conversation_id

    with _sqlite_connection() as connection:
        connection.executemany(
            """
            INSERT INTO conversation_messages (
                message_id, conversation_id, user_id, client, role, content, sequence, created_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """,
            [
                (
                    uuid.uuid4().hex,
                    conversation_id,
                    user_id,
                    client,
                    message["role"],
                    message["content"],
                    message["sequence"],
                    created_at.isoformat(),
                )
                for message in messages
            ],
        )
    return conversation_id


def get_conversation_messages(conversation_id: str) -> list[dict]:
    database = _mongo_database()
    if database is not None:
        conversation = database.conversations.find_one({"_id": conversation_id})
        if conversation is None:
            return []
        return [
            {
                "conversationId": conversation_id,
                "userId": conversation.get("userId"),
                "client": conversation["client"],
                "role": message["role"],
                "content": message["content"],
                "sequence": message["sequence"],
                "createdAt": _timestamp_string(conversation["createdAt"]),
            }
            for message in conversation["messages"]
        ]

    with _sqlite_connection() as connection:
        rows = connection.execute(
            """
            SELECT conversation_id, user_id, client, role, content, sequence, created_at
            FROM conversation_messages
            WHERE conversation_id = ?
            ORDER BY sequence
            """,
            (conversation_id,),
        ).fetchall()
    return [
        {
            "conversationId": row["conversation_id"],
            "userId": row["user_id"],
            "client": row["client"],
            "role": row["role"],
            "content": row["content"],
            "sequence": row["sequence"],
            "createdAt": row["created_at"],
        }
        for row in rows
    ]


def check_database() -> None:
    database = _mongo_database()
    if database is not None:
        database.client.admin.command("ping")
        database.saved_ideas.create_index([("userId", 1), ("createdAt", -1)])
        database.conversations.create_index([("userId", 1), ("createdAt", -1)])
        return

    with _sqlite_connection():
        pass


def database_backend() -> str:
    return "mongodb" if _mongo_uri() else "sqlite"
