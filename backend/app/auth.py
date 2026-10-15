import os
from functools import lru_cache
from urllib.error import URLError

import jwt
from fastapi import Header, HTTPException
from jwt import PyJWKClient
from jwt.exceptions import PyJWKClientConnectionError, PyJWKClientError, PyJWTError


@lru_cache(maxsize=4)
def _jwks_client(url: str) -> PyJWKClient:
    return PyJWKClient(url, cache_keys=True, timeout=5)


def get_current_user_id(authorization: str | None = Header(default=None)) -> str:
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Sign in to continue")

    issuer = os.environ.get("CLERK_ISSUER", "").rstrip("/")
    jwks_url = os.environ.get("CLERK_JWKS_URL", "")
    if not jwks_url and issuer:
        jwks_url = f"{issuer}/.well-known/jwks.json"
    if not issuer or not jwks_url:
        raise HTTPException(status_code=503, detail="Clerk authentication is not configured")

    token = authorization.removeprefix("Bearer ").strip()
    if not token:
        raise HTTPException(status_code=401, detail="Sign in to continue")

    try:
        signing_key = _jwks_client(jwks_url).get_signing_key_from_jwt(token)
        claims = jwt.decode(
            token,
            signing_key.key,
            algorithms=["RS256"],
            issuer=issuer,
            options={"require": ["exp", "iss", "sub"]},
            leeway=30,
        )
    except PyJWKClientConnectionError as exc:
        raise HTTPException(status_code=503, detail="Could not reach Clerk to verify your session") from exc
    except (PyJWKClientError, PyJWTError) as exc:
        raise HTTPException(status_code=401, detail="Your sign-in session is invalid or expired") from exc
    except (URLError, TimeoutError, OSError) as exc:
        raise HTTPException(status_code=503, detail="Could not reach Clerk to verify your session") from exc

    authorized_parties = {
        origin.strip().rstrip("/")
        for origin in os.environ.get(
            "CLERK_AUTHORIZED_PARTIES",
            "https://founder-os-gold-iota.vercel.app,http://localhost:3000,http://127.0.0.1:3000",
        ).split(",")
        if origin.strip()
    }
    authorized_party = claims.get("azp")
    if authorized_party and authorized_party not in authorized_parties:
        raise HTTPException(status_code=401, detail="This website is not authorized for your Clerk session")

    user_id = claims.get("sub")
    if not isinstance(user_id, str) or not user_id:
        raise HTTPException(status_code=401, detail="Clerk session does not identify a user")
    return user_id


def get_optional_current_user_id(authorization: str | None = Header(default=None)) -> str | None:
    if not authorization:
        return None
    return get_current_user_id(authorization)
