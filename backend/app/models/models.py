from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, Table, Time, TIMESTAMP, text, Float, SmallInteger, Date, Text
from sqlalchemy.orm import relationship
from ..database import Base

# --- JOIN TABLES (Many-to-Many Bridges) ---

# Link between Menus and Plats
menu_plats = Table(
    "menus_plats",
    Base.metadata,
    Column("menu_id", Integer, ForeignKey("menus.menu_id", ondelete="CASCADE"), primary_key=True),
    Column("plat_id", Integer, ForeignKey("plats.plat_id", ondelete="CASCADE"), primary_key=True),
)

# Link between Plats and Allergenes
plats_allergenes = Table(
    "plats_allergenes",
    Base.metadata,
    Column("plat_id", Integer, ForeignKey("plats.plat_id", ondelete="CASCADE"), primary_key=True),
    Column("allergene_id", Integer, ForeignKey("allergenes.allergene_id", ondelete="CASCADE"), primary_key=True),
)

# Link between Menus and Themes
menus_themes = Table(
    "menus_themes",
    Base.metadata,
    Column("menu_id", Integer, ForeignKey("menus.menu_id", ondelete="CASCADE"), primary_key=True),
    Column("theme_id", Integer, ForeignKey("themes.theme_id", ondelete="CASCADE"), primary_key=True),
)

# --- CORE MODELS ---

class User(Base):
    __tablename__ = "utilisateurs"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(50), unique=True, index=True, nullable=False)
    password_hash = Column(String(255), nullable=False)  # Long enough for Bcrypt/Argon2
    prenom = Column(String(50))
    nom = Column(String(50))
    telephone = Column(String(50))
    adresse = Column(String(50))
    code_postal = Column(String(50))
    ville = Column(String(50))
    role = Column(String(20), server_default="Customer") # Admin, Employee, Customer
    
    # Audit fields
    created_at = Column(TIMESTAMP, server_default=text('CURRENT_TIMESTAMP'))
    updated_at = Column(TIMESTAMP, server_default=text('CURRENT_TIMESTAMP'), onupdate=text('CURRENT_TIMESTAMP'))
    is_deleted = Column(Boolean, default=False)

    # Relationships
    orders = relationship("Order", back_populates="owner")
    reviews = relationship("Review", back_populates="author")


class Menu(Base):
    __tablename__ = "menus"

    menu_id = Column(Integer, primary_key=True, index=True)
    title = Column(String(50), nullable=False)
    nombre_personnes_min = Column(Integer, default=1)
    prix_par_personne = Column(Float, nullable=False)
    description = Column(Text)
    quantite_disponible = Column(Integer)
    images_url = Column(String(255))
    is_active = Column(Boolean, default=True)
    
    # Foreign Key to Regime (Many-to-One)
    regime_id = Column(Integer, ForeignKey("regimes.regime_id"))
    
    # Relationships
    regime = relationship("Regime", back_populates="menus")
    plats = relationship("Plat", secondary=menu_plats, back_populates="menus")
    themes = relationship("Theme", secondary=menus_themes, back_populates="menus")


class Plat(Base):
    __tablename__ = "plats"

    plat_id = Column(Integer, primary_key=True, index=True)
    title = Column(String(50), nullable=False)
    categorie = Column(String(20)) # "entrée", "principal", "dessert"
    images_url = Column(String(255))
    
    # Relationships
    menus = relationship("Menu", secondary=menu_plats, back_populates="plats")
    allergenes = relationship("Allergene", secondary=plats_allergenes, back_populates="plats")


class Order(Base):
    __tablename__ = "commandes"

    id = Column(Integer, primary_key=True, index=True)
    numero_commande = Column(String(50), unique=True, nullable=False)
    user_id = Column(Integer, ForeignKey("utilisateurs.id"))
    date_prestation = Column(Date, nullable=False)
    heure_livraison = Column(Time)
    prix_total = Column(Float, nullable=False)
    remise_appliquee = Column(Float, default=0.0) # Handle that 10% discount
    statut = Column(String(50), default="en attente de règlement")
    
    # Audit & Tracking
    created_at = Column(TIMESTAMP, server_default=text('CURRENT_TIMESTAMP'))
    owner = relationship("User", back_populates="orders")
    details = relationship("OrderDetails", back_populates="order")


class OrderDetails(Base):
    __tablename__ = "commande_details"

    id = Column(Integer, primary_key=True, index=True)
    order_id = Column(Integer, ForeignKey("commandes.id"))
    menu_id = Column(Integer, ForeignKey("menus.menu_id"))
    quantity = Column(Integer, nullable=False)
    prix_applique = Column(Float, nullable=False) # Important: Price at time of purchase

    order = relationship("Order", back_populates="details")


class Review(Base):
    __tablename__ = "avis"

    id = Column(Integer, primary_key=True, index=True)
    note = Column(SmallInteger) # 0 to 5
    description = Column(Text)
    user_id = Column(Integer, ForeignKey("utilisateurs.id"))
    menu_id = Column(Integer, ForeignKey("menus.menu_id"))
    statut = Column(String(20), default="en attente") # "en attente", "accepté", "rejeté"
    
    author = relationship("User", back_populates="reviews")


# --- HELPER TABLES (Regimes, Themes, Allergenes) ---

class Regime(Base):
    __tablename__ = "regimes"
    regime_id = Column(Integer, primary_key=True)
    libelle = Column(String(50), nullable=False)
    menus = relationship("Menu", back_populates="regime")

class Theme(Base):
    __tablename__ = "themes"
    theme_id = Column(Integer, primary_key=True)
    libelle = Column(String(50), nullable=False)
    menus = relationship("Menu", secondary=menus_themes, back_populates="themes")

class Allergene(Base):
    __tablename__ = "allergenes"
    allergene_id = Column(Integer, primary_key=True)
    libelle = Column(String(50), nullable=False)
    plats = relationship("Plat", secondary=plats_allergenes, back_populates="allergenes")