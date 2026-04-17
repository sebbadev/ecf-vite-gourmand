#!/bin/bash
# root_scaffold.sh - Full Project Workspace Setup

echo "--- Starting Global Project Scaffolding ---"

# 1. Create Root Layer Folders
mkdir -p backend frontend docs/conception docs/sql scripts admin

# 2. Create Backend Sub-structure
mkdir -p backend/app/core backend/app/crud backend/app/models \
         backend/app/routers backend/app/schemas backend/temp backend/alembic

# 3. Initialize Python Packages (__init__.py)
touch backend/app/__init__.py \
      backend/app/core/__init__.py \
      backend/app/crud/__init__.py \
      backend/app/models/__init__.py \
      backend/app/routers/__init__.py \
      backend/app/schemas/__init__.py

# 4. Create Root level configuration files
touch .gitignore README.md .env.example

# 5. Create Backend specific files
touch backend/main.py backend/database.py backend/requirements.txt backend/.env

echo "--- Directory Structure Created ---"

# 6. Inject Global .gitignore
cat <<EOF > .gitignore
# Secrets
.env
backend/.env
admin/

# Project Tools & Temporary Map Files
*_tree.txt
full_sync.txt
project_map.txt

# Python
backend/venv/
backend/.venv/
**/__pycache__/
*.py[cod]

# Frontend (Angular)
frontend/node_modules/
frontend/dist/
frontend/.angular/

# System/Logs
*.log
.DS_Store
EOF

echo "--- Global .gitignore Ready ---"

# 7. Create the first script in the scripts folder
cat <<EOF > scripts/generate_tree.sh
#!/bin/bash
# Usage: ./scripts/generate_tree.sh [directory_path]
TARGET_DIR=\${1:-"."}
DIR_NAME=\$(basename "\$TARGET_DIR")
OUTPUT_FILE="\${DIR_NAME}_tree.txt"

echo "Generating map for: \$TARGET_DIR"
tree "\$TARGET_DIR" -I 'venv|node_modules|__pycache__|.git' -L 3 > "\$OUTPUT_FILE"
echo "Success: Created \$OUTPUT_FILE"
EOF

chmod +x scripts/generate_tree.sh

echo "--- Scaffolding Complete ---"