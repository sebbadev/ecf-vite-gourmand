#!/bin/bash
# scripts/generate_code.sh - Full snapshot (Tree + Code)
# Usage: ./scripts/generate_code.sh [directory_path]

# 1. Target the folder passed as an argument, or default to current directory
TARGET_DIR=${1:-"."}
# Get the absolute path to be sure where we are
ABS_PATH=$(realpath "$TARGET_DIR")
DIR_NAME=$(basename "$ABS_PATH")
OUTPUT_FILE="${DIR_NAME}_code_snapshot.txt"

echo "--- Generating Full Snapshot for: $DIR_NAME ---"

# 2. Add the Tree Structure first
echo "--- PROJECT STRUCTURE ---" > "$OUTPUT_FILE"
tree "$TARGET_DIR" -I 'venv|node_modules|__pycache__|.git' -L 3 >> "$OUTPUT_FILE"

# 3. Add the actual code content
echo -e "\n--- CODE CONTENT ---" >> "$OUTPUT_FILE"

# find looks for all .py files in TARGET_DIR and deeper
# -not -path filters out the virtual environment for safety
find "$TARGET_DIR" -type f -name "*.py" -not -path "*/venv/*" -not -path "*/__pycache__/*" | while read -r file; do
    echo -e "\n\n--- FILE: $file ---" >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE"
done

echo "Success: Created $OUTPUT_FILE"
