import json
import os
import sqlite3
from contextlib import contextmanager
from datetime import datetime, timezone
from pathlib import Path
from typing import Iterator


def _database_path() -> Path:
    configured_path = os.environ.get("DATABASE_PATH")
    if configured_path:
        return Path(configured_path)
    return Path(__file__).resolve().parents[1] / "data" / "founderos.sqlite3"


@contextmanager
def _connection() -> Iterator[sqlite3.Connection]:
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
        yield connection
        connection.commit()
    finally:
        connection.close()


def save_idea(user_id: str, idea: str, analysis: dict) -> dict:
    created_at = datetime.now(timezone.utc).isoformat()
    analysis_json = json.dumps(analysis, ensure_ascii=False)
    with _connection() as connection:
        connection.execute(
            """
            INSERT INTO saved_ideas (id, user_id, idea, analysis_json, created_at)
            VALUES (?, ?, ?, ?, ?)
            """,
            (analysis["id"], user_id, idea, analysis_json, created_at),
        )
    return {
        "id": analysis["id"],
        "idea": idea,
        "analysis": analysis,
        "createdAt": created_at,
    }


def list_ideas(user_id: str) -> list[dict]:
    with _connection() as connection:
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
    with _connection() as connection:
        cursor = connection.execute(
            "DELETE FROM saved_ideas WHERE id = ? AND user_id = ?",
            (idea_id, user_id),
        )
    return cursor.rowcount > 0
