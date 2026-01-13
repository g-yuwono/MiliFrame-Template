#!/bin/bash
# ============================================
# Script: update_env.sh
# Purpose: Update requirements.txt (Pip only)
# Author: Mike C. Li (Revised)
# ============================================

# Exit if any command fails
set -e

echo ">>> Please confirm you are in the correct conda environment."
echo -n "Enter the name of the conda environment to update: "
read ENV_NAME

if [ "$ENV_NAME" != "$CONDA_DEFAULT_ENV" ]; then
    echo "Error: You are not in the '$ENV_NAME' conda environment."
    echo "Please activate it using: conda activate $ENV_NAME"
    exit 1
fi

echo ">>> NOTE: environment.yml is now static (Python version only) and will not be touched."

echo ">>> Exporting all library dependencies to requirements.txt..."
# We use pip freeze to capture the exact versions of all installed libraries
pip freeze > requirements.txt

echo ">>> Done."
echo ">>> Please commit the updated file:"
echo "    git add requirements.txt"
echo "    git commit -m 'update requirements.txt'"