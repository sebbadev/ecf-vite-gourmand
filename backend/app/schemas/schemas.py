from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List
from datetime import date, time, datetime

# --- USER SCHEMAS ---

class UserBase(BaseModel):
    """Common attributes for Users"""
    email: EmailStr
    prenom: Optional[str] = None
    nom: Optional[str] = None

class UserCreate(UserBase):
    """Attributes needed to create a user (Signup)"""
    password: str = Field(..., min_length=8) # Requirement for security

class UserResponse(UserBase):
    """Attributes returned to the frontend (Never return the password!)"""
    id: int
    role: str
    created_at: datetime

    class Config:
        from_attributes = True # Allows Pydantic to read SQLAlchemy models

# --- MENU SCHEMAS ---

class MenuBase(BaseModel):
    title: str
    prix_par_personne: float
    description: Optional[str] = None
    is_active: bool = True

class MenuResponse(MenuBase):
    menu_id: int
    images_url: Optional[str] = None

    class Config:
        from_attributes = True

# --- ORDER SCHEMAS ---

class OrderCreate(BaseModel):
    """What Angular sends when a customer clicks 'Order'"""
    date_prestation: date
    heure_livraison: time
    nombre_personnes: int
    menu_ids: List[int] # List of menus being ordered

class OrderResponse(BaseModel):
    id: int
    numero_commande: str
    prix_total: float
    statut: str
    
    class Config:
        from_attributes = True