import os
from fastapi.security import OAuth2PasswordBearer
from datetime import datetime, timedelta
from jose import jwt
from dotenv import load_dotenv

# Update the tokenUrl to match your main.py prefix + router path
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="api/auth/login")

load_dotenv()

# We need a secret key to sign our tokens
# For now, we use a placeholder, but in production, this stays in .env
SECRET_KEY = os.getenv("SECRET_KEY", "SUPER_SECRET_RESTAURANT_KEY_2026")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60

def create_access_token(data: dict):
    """Generates a JWT token for a user"""
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt