from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from ..database import get_db
from ..models import models
from ..schemas import schemas
from ..core import security
from ..core.auth import oauth2_scheme

router = APIRouter()

@router.post("/signup", response_model=schemas.UserResponse, status_code=status.HTTP_201_CREATED)
def signup(user: schemas.UserCreate, db: Session = Depends(get_db)):
    """
    Create a new user account. 
    Passwords are automatically hashed before being stored.
    """
    # 1. Check if the email already exists to avoid duplicates
    db_user = db.query(models.User).filter(models.User.email == user.email).first()
    if db_user:
        raise HTTPException(
            status_code=400, 
            detail="Email already registered. Try logging in."
        )

    # 2. Hash the plain-text password
    hashed_password = security.get_password_hash(user.password)
    
    # 3. Create the Database object
    new_user = models.User(
        email=user.email,
        password_hash=hashed_password,
        prenom=user.prenom,
        nom=user.nom,
        role="Customer"  # Default role for new signups
    )
    
    # 4. Save to PostgreSQL
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    
    return new_user

@router.get("/me", response_model=schemas.UserResponse)
def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    """
    This route is PROTECTED. 
    The 'Depends(oauth2_scheme)' is what triggers the padlock icon.
    """
    return {"message": "You are authorized!"}