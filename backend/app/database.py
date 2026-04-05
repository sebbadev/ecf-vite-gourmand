# Import necessary tools from SQLAlchemy
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# Database URL: Replace with your actual credentials
# Format: postgresql://user:password@postgresserver/db_name
SQLALCHEMY_DATABASE_URL = "postgresql://user:password@localhost/vite_gourmand"

# The Engine is the starting point for any SQLAlchemy application
# it's the "plumbing" that maintains the connection pool
engine = create_engine(SQLALCHEMY_DATABASE_URL)

# Each instance of the SessionLocal class will be a database session
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# We will inherit from this class to create each of the database models
Base = declarative_base()

# Dependency to get the DB session for each request
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()