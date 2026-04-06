-- -----------------------------------------------------
-- Database Creation Script for Vite & Gourmand
-- Project: ECF TP RNCP 37674
-- -----------------------------------------------------

-- 1. Custom Types (Enums) for better data integrity
CREATE TYPE status_commande AS ENUM (
    'accepté', 'en préparation', 'en cours de livraison', 
    'livré', 'en attente de règlement', 'en attente du retour matériel', 'terminée'
);

CREATE TYPE status_avis AS ENUM ('en attente', 'accepté', 'répondu', 'rejeté');

CREATE TYPE categorie_plat AS ENUM ('entrée', 'principal', 'dessert');

-- 2. Horaires Table
CREATE TABLE horaires (
    horaire_id SERIAL PRIMARY KEY,
    jour VARCHAR(50) NOT NULL,
    heure_ouverture TIME NOT NULL,
    heure_fermeture TIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 3. Utilisateurs Table
CREATE TABLE utilisateurs (
    id SERIAL PRIMARY KEY,
    email VARCHAR(50) UNIQUE NOT NULL,
    mot_de_passe_hash VARCHAR(255) NOT NULL,
    prenom VARCHAR(50),
    nom VARCHAR(50),
    telephone VARCHAR(50),
    adresse VARCHAR(50),
    code_postal VARCHAR(50),
    ville VARCHAR(50),
    pays VARCHAR(50),
    role VARCHAR(20) DEFAULT 'Customer', -- Admin, Employee, Customer
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 4. Regimes Table
CREATE TABLE regimes (
    regime_id SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 5. Menus Table
CREATE TABLE menus (
    menu_id SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    nombre_personnes_min INT DEFAULT 1,
    prix_par_personne DOUBLE PRECISION NOT NULL,
    regime_id INT REFERENCES regimes(regime_id),
    description TEXT,
    quantite_disponible INT,
    images_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 6. Plats Table
CREATE TABLE plats (
    plat_id SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    categorie categorie_plat NOT NULL,
    images_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 7. Allergènes Table
CREATE TABLE allergenes (
    allergene_id SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 8. Themes Table
CREATE TABLE themes (
    theme_id SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 9. Commandes Table
CREATE TABLE commandes (
    id SERIAL PRIMARY KEY,
    numero_commande VARCHAR(50) UNIQUE NOT NULL,
    user_id INT REFERENCES utilisateurs(id),
    commande_date_validation DATE,
    date_prestation DATE NOT NULL,
    heure_livraison TIME,
    nombre_personnes INT NOT NULL,
    prix_livraison DOUBLE PRECISION DEFAULT 0.0,
    remise_appliquee DOUBLE PRECISION DEFAULT 0.0,
    prix_total DOUBLE PRECISION NOT NULL,
    statut status_commande DEFAULT 'en attente de règlement',
    pret_materiel BOOLEAN DEFAULT FALSE,
    restitution_materiel BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 10. Commande_Details Table (Join Table between Commandes and Menus)
CREATE TABLE commande_details (
    id SERIAL PRIMARY KEY,
    commande_id INT REFERENCES commandes(id) ON DELETE CASCADE,
    menu_id INT REFERENCES menus(menu_id),
    quantity INT NOT NULL,
    prix_applique DOUBLE PRECISION NOT NULL, -- Price at the moment of order
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 11. Avis Table
CREATE TABLE avis (
    id SERIAL PRIMARY KEY,
    note SMALLINT CHECK (note >= 0 AND note <= 5),
    description TEXT,
    user_id INT REFERENCES utilisateurs(id),
    menu_id INT REFERENCES menus(menu_id),
    statut status_avis DEFAULT 'en attente',
    avis_date_validation DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 12. Join Tables for Many-to-Many Relationships
CREATE TABLE menus_plats (
    menu_id INT REFERENCES menus(menu_id) ON DELETE CASCADE,
    plat_id INT REFERENCES plats(plat_id) ON DELETE CASCADE,
    PRIMARY KEY (menu_id, plat_id)
);

CREATE TABLE plats_allergenes (
    plat_id INT REFERENCES plats(plat_id) ON DELETE CASCADE,
    allergene_id INT REFERENCES allergenes(allergene_id) ON DELETE CASCADE,
    PRIMARY KEY (plat_id, allergene_id)
);

CREATE TABLE menus_themes (
    menu_id INT REFERENCES menus(menu_id) ON DELETE CASCADE,
    theme_id INT REFERENCES themes(theme_id) ON DELETE CASCADE,
    PRIMARY KEY (menu_id, theme_id)
);

CREATE TABLE plats_regimes (
    plat_id INT REFERENCES plats(plat_id) ON DELETE CASCADE,
    regime_id INT REFERENCES regimes(regime_id) ON DELETE CASCADE,
    PRIMARY KEY (plat_id, regime_id)
);