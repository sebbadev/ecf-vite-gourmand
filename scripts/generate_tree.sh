#!/bin/bash
# Run this from the project root

# 1. Target the folder passed as an argument, or default to root
TARGET_DIR=${1:-"."}
DIR_NAME=$(basename "$TARGET_DIR")

# 2. Name the output file
OUTPUT_FILE="${DIR_NAME}_tree.txt"

echo "--- Generating map for: $TARGET_DIR ---"

# 3. Use tree, ignoring the venv and node_modules
tree "$TARGET_DIR" -I 'venv|node_modules|__pycache__|.git' -L 3 > "$OUTPUT_FILE"

echo "Success: Created $OUTPUT_FILE"
