#!/bin/bash

# Ensure we exit on error
set -e

# Default branch name prefix
DEFAULT_BRANCH="demo/release-please-$(date +%s)"

echo "Starting Conventional Commits Demo Setup..."

# Check if inside a git repository
if [ ! -d ".git" ] && [ ! -d "../.git" ]; then
    echo "Error: Not a git repository. Please run from the root or demo directory."
    exit 1
fi

# Ask for branch name
read -p "Enter branch name to add commits (default: $DEFAULT_BRANCH): " BRANCH_NAME
BRANCH_NAME=${BRANCH_NAME:-$DEFAULT_BRANCH}

echo "Creating and checking out branch: $BRANCH_NAME"
git checkout "$BRANCH_NAME"

# Create dummy commits with conventional messages
echo "Generating commits..."

# Feature
echo "1. Creating a 'feat' commit..."
git commit --allow-empty -m "feat: add new demo component structure with enhanced behaviour"

# Fix
echo "2. Creating a 'fix' commit..."
git commit --allow-empty -m "fix: resolve parsing error in demo script"

# Documentation
echo "3. Creating a 'docs' commit..."
git commit --allow-empty -m "docs: update readme with usage instructions"

# Performance improvement
echo "4. Creating a 'perf' commit..."
git commit --allow-empty -m "perf: optimise startup time for demo service"

# Breaking Change
echo "5. Creating a BREAKING CHANGE commit..."
git commit --allow-empty -m "feat!: change behavior of main component

BREAKING CHANGE: The main entry point has changed from main() to start()."

echo "--------------------------------------------------------"
echo "Demo commits created successfully on branch '$BRANCH_NAME'!"
echo "--------------------------------------------------------"
echo "Next steps:"
echo "1. Push this branch: git push -u origin $BRANCH_NAME"
echo "2. Open a Pull Request to merge these changes into 'main' (or your demo target branch)."
echo "3. Once merged, the release-please action will run and create a Release PR."
