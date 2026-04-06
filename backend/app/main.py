from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from .database import engine, Base, get_db
from .models import models # This ensures models are known to SQLAlchemy
from .routers import menus

# This command tells SQLAlchemy to create the tables in PostgreSQL 
# if they don't exist yet. Very useful for the first run!
models.Base.metadata.create_all(bind=engine)

# Initialize the FastAPI app
app = FastAPI(title="Vite & Gourmand API")
app.include_router(menus.router, prefix="/api/menus", tags=["Menus"])

@app.get("/")
def read_root():
    """Simple endpoint to test if the server is alive"""
    return {"message": "Welcome to Vite & Gourmand API", "status": "online"}

@app.get("/test-db")
def test_db(db: Session = Depends(get_db)):
    """Endpoint to test the connection to PostgreSQL"""
    try:
        # We try a very simple query to see if the DB responds
        db.execute(models.text("SELECT 1"))
        return {"status": "Database connection successful"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database connection failed: {str(e)}")