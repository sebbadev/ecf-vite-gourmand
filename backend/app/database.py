import os
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv

# Load variables from the .env file
load_dotenv()

# We get the database URL from an environment variable for security
# If not found, it defaults to a local postgres (useful for dev)
SQLALCHEMY_DATABASE_URL = os.getenv(
    "DATABASE_URL", 
    "postgresql://postgres:password@localhost/vite_gourmand"
)

# Create the Engine: The bridge between Python and PostgreSQL
engine = create_engine(SQLALCHEMY_DATABASE_URL)

# SessionLocal: Each instance will be a database "conversation"
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base: The class our models will inherit from
Base = declarative_base()

# Dependency: This function will provide a DB session to our API routes
# and ensure the connection is closed after the request is finished
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()