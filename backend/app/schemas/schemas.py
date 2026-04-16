from pydantic import BaseModel, EmailStr, ConfigDict
from typing import List, Optional
from datetime import datetime, date, time
from models import UserRole, OrderStatus, PaymentStatus, Equipment, DishType, Rating

# --- 1. Base Schemas (Common attributes) ---

class ThemeBase(BaseModel):
    libelle: str

class AllergeneBase(BaseModel):
    libelle: str

class RegimeBase(BaseModel):
    libelle: str

# --- 2. Plat (Dish) Schemas ---

class PlatBase(BaseModel):
    titre: str
    type_de_plat: DishType
    images_url: Optional[str] = None

class PlatRead(PlatBase):
    plat_id: int
    allergenes: List[AllergeneBase] = []
    regimes: List[RegimeBase] = []
    
    model_config = ConfigDict(from_attributes=True) # Allows Pydantic to read SQLAlchemy models

# --- 3. Menu Schemas ---

class MenuBase(BaseModel):
    titre: str
    nombre_personnes_min: int
    prix_par_personne: float
    description: str
    quantite_disponible: int
    images_url: str
    is_active: bool = True

class MenuRead(MenuBase):
    menu_id: int
    plats: List[PlatRead] = []
    # These use the @property logic we wrote in models.py
    allergenes: List[AllergeneBase] 
    regimes_valides: List[str] 
    
    model_config = ConfigDict(from_attributes=True)

# --- 4. User Schemas ---

class UserBase(BaseModel):
    email: EmailStr
    prenom: str
    nom: str
    telephone: Optional[str] = None
    role: UserRole = UserRole.CLIENT

class UserCreate(UserBase):
    password: str # Used only for registration

class UserRead(UserBase):
    user_id: int
    created_at: datetime
    
    model_config = ConfigDict(from_attributes=True)

# --- 5. Order Schemas ---

class CommandeDetailBase(BaseModel):
    menu_id: int
    quantite: int
    prix_applique: float

class CommandeBase(BaseModel):
    date_prestation: date
    heure_livraison: datetime
    statut: OrderStatus = OrderStatus.PENDING
    statut_materiel: Equipment = Equipment.INCLUDED

class CommandeRead(CommandeBase):
    commande_id: int
    numero_commande: str
    prix_total: float
    statut_paiement: PaymentStatus
    details: List[CommandeDetailBase]
    
    model_config = ConfigDict(from_attributes=True)