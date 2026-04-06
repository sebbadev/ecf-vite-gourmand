from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from ..database import get_db
from ..models import models
from ..schemas import schemas

router = APIRouter()

@router.post("/", response_model=schemas.MenuResponse)
def create_menu(menu: schemas.MenuBase, db: Session = Depends(get_db)):
    """Add a new menu to the database"""
    db_menu = models.Menu(
        title=menu.title,
        description=menu.description,
        prix_par_personne=menu.prix_par_personne,
        is_active=menu.is_active
    )
    db.add(db_menu)
    db.commit()
    db.refresh(db_menu)
    return db_menu

@router.get("/", response_model=List[schemas.MenuResponse])
def get_all_menus(db: Session = Depends(get_db)):
    """List all available menus"""
    return db.query(models.Menu).all()