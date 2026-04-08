from passlib.context import CryptContext

# Configuration for the hashing algorithm
# we use bcrypt because it is industry standard and secure against brute force
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def get_password_hash(password: str) -> str:
    """Transforms a plain-text password into a secure, unreadable hash."""
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Checks if a provided password matches the stored hash in the DB."""
    return pwd_context.verify(plain_password, hashed_password)