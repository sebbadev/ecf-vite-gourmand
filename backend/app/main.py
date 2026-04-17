from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from .database import engine, get_db
from app.models.models import Base
from app.routers import users, menus, auth

Base.metadata.create_all(bind=engine)

# Initialize the FastAPI app
app = FastAPI(title="Vite & Gourmand API")
app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])
app.include_router(users.router, prefix="/api/users", tags=["Users"])
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
        db.execute(Base.metadata.tables["users"].select())
        return {"status": "Database connection successful"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database connection failed: {str(e)}")