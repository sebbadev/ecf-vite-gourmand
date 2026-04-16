from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import models
from app.schemas import schemas
from app.core import security
from app.core.auth import get_current_user

router = APIRouter()

@router.post("/signup", response_model=schemas.UserRead, status_code=status.HTTP_201_CREATED)
def signup(user: schemas.UserCreate, db: Session = Depends(get_db)):
    """
    Create a new user account. 
    Passwords are automatically hashed before being stored.
    """
    # 1. Check if the email already exists to avoid duplicates
    db_user = db.query(models.Utilisateur).filter(models.Utilisateur.email == user.email).first()
    if db_user:
        raise HTTPException(
            status_code=400, 
            detail="Email already registered. Try logging in."
        )

    # 2. Hash the plain-text password
    hashed_password = security.get_password_hash(user.password)
    
    # 3. Create the Database object
    new_user = models.Utilisateur(
        email=user.email,
        password_hash=hashed_password,
        prenom=user.prenom,
        nom=user.nom,
        role="Customer"
    )
    
    # 4. Save to PostgreSQL
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    
    return new_user

@router.get("/me", response_model=schemas.UserRead)
def read_users_me(current_user: models.Utilisateur = Depends(get_current_user)):

    return current_user