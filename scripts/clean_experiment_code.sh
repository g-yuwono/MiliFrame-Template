#!/usr/bin/env bash
set -e  # Exit immediately on error

# --- Step 1: Read EXP_ID ---
if [ ! -f ".exp_online" ]; then
    echo "❌ ERROR: '.exp_online' file not found."
    exit 1
fi

EXP_ID=$(cat .exp_online | tr -d '[:space:]')
BASE_DIR="./artifacts/runs_${EXP_ID}"

# --- Step 2: Check if source and target folders exist ---
if [ ! -d "${BASE_DIR}/notebooks" ]; then
    echo "❌ ERROR: Directory '${BASE_DIR}/notebooks' not found."
    exit 1
fi

if [ ! -d "${BASE_DIR}/nbs" ]; then
    echo "❌ ERROR: Directory '${BASE_DIR}/nbs' not found. Please create it manually before running this script."
    exit 1
fi

echo "📁 BASE_DIR = ${BASE_DIR}"

# --- NEW: Clear the target nbs directory ---
echo "🗑️ Cleaning up previous contents in '${BASE_DIR}/nbs'..."
find "${BASE_DIR}/nbs" -mindepth 1 -delete

echo "➡️ Copying .py and .ipynb files (excluding .ipynb_checkpoints)..."

SOURCE_DIR="${BASE_DIR}/notebooks/"
TARGET_DIR="${BASE_DIR}/nbs/"

# Copy all .py and .ipynb files, excluding .ipynb_checkpoints directories
echo "➡️ Synchronizing .py and .ipynb files including subdirectories, excluding checkpoints..."
rsync -a \
    --exclude='__pycache__/' \
    --exclude='.ipynb_checkpoints/' \
    --include='*/' \
    --include='*.py' \
    --include='*.ipynb' \
    --exclude='*' \
    --prune-empty-dirs \
    "${SOURCE_DIR}" \
    "${TARGET_DIR}"

# --- Step 3: Convert .ipynb files to .py (Recursive) ---
echo "🪄 Converting .ipynb notebooks (including subfolders) to .py scripts..."

# Use find to recursively locate all .ipynb files and execute nbconvert
find "${BASE_DIR}/nbs" -type f -name "*.ipynb" -print0 | while IFS= read -r -d $'\0' nb; do
    # Extract the directory of the file, which serves as the output directory for nbconvert
    NB_DIR=$(dirname "$nb")

    # Execute the conversion, outputting the .py file to the same directory as the original .ipynb
    # Note: nbconvert by default outputs the converted .py file to the same directory as the .ipynb
    echo "   -> Converting: $nb"
    jupyter nbconvert --to script "$nb" --output-dir "$NB_DIR" >/dev/null 2>&1
done

# --- Step 3.5: Clean up trailing whitespace in converted .py files ---
echo "✨ Cleaning up trailing whitespace in all generated .py files..."
# The sed command removes zero or more whitespace characters ([[:space:]]*) right before the end of the line ($).
# IMPORTANT: If running on macOS (BSD sed), change the command to:
# find ... -exec sed -i '' 's/[[:space:]]*$//' {} +
find "${BASE_DIR}/nbs" -type f -name "*.py" -exec sed -i 's/[[:space:]]*$//' {} +
echo "✅ Trailing whitespace cleanup complete."

# --- Step 4: Remove all non-.py files (Recursive) ---
echo "🧹 Recursively removing non-.py files..."
# Use find to recursively locate and delete all non-.py files under the nbs directory
find "${BASE_DIR}/nbs" -type f ! -name "*.py" -delete

echo "✅ Cleanup complete: ${BASE_DIR}/nbs"
