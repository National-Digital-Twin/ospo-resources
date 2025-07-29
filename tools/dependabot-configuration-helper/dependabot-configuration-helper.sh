# SPDX-License-Identifier: Apache-2.0
# © Crown Copyright 2025. This work has been developed by the National Digital Twin Programme and is legally attributed to the Department for Business and Trade (UK) as the governing entity.

# This script has been developed to create proposed Dependabot configurations based on repository contents.
# Groups, as described at https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/optimizing-pr-creation-version-updates
# have been used to help reduce the number of pull requests opened for a given ecosystem. This is to reduce
# the volume of GitHub action minutes consumed as part of patching activities, and also allows for package
# updates (via CI pipelines) to be tested in concert.

#!/bin/bash

# Exit on error
set -e

read -p "Enter the update frequency (daily, weekly, or monthly) [default: weekly]: " frequency
frequency=${frequency:-weekly}

case "$frequency" in
  daily|weekly|monthly) ;;
  *)
    echo "Invalid frequency. Use 'daily', 'weekly', or 'monthly'."
    exit 1
    ;;
esac

read -p "Enter the target branch for Dependabot PRs [default: develop]: " target_branch
target_branch=${target_branch:-develop}

read -p "Enable major version patching? (yes/no) [default: yes]: " allow_major
allow_major=${allow_major:-yes}

case "$allow_major" in
  yes|no) ;;
  *)
    echo "Invalid input. Use 'yes' or 'no'."
    exit 1
    ;;
esac

# Output file path
mkdir -p .github
output_file=".github/dependabot-proposed.yml"

if [ -f "$output_file" ]; then
  echo "Existing proposed configuration found. Removing: $output_file"
  rm "$output_file"
fi

# Start writing proposed configuration
cat > "$output_file" <<EOF
# This is a proposed Dependabot configuration.
# To enable it, rename this file to: .github/dependabot.yml

version: 2
updates:
EOF

# Function to add a package ecosystem to the Dependabot configuration
add_dependabot_ecosystem() {
  local ecosystem="$1"
  local directory="$2"
  local group="$3"

  echo "" >> "$output_file"  # Add a blank line before each entry

  cat >> "$output_file" <<EOF
  - package-ecosystem: "$ecosystem"
    directory: "$directory"
    target-branch: "$target_branch"
    schedule:
      interval: "$frequency"
    groups:
      $group:
        patterns:
          - "*"
EOF

  if [[ "$allow_major" == "no" ]]; then
    cat >> "$output_file" <<EOF
    ignore:
      - dependency-name: "*"
        update-types:
          - "version-update:semver-major"
EOF
  fi
}

# Excludes common directories
filtered_find() {
  find . \
    -type d \( \
      -name node_modules -o \
      -name __pycache__ -o \
      -name .venv -o \
      -name .env -o \
      -name venv -o \
      -name env -o \
      -name target -o \
      -name .idea -o \
      -name .m2 \
      -name .gradle \
    \) -prune -false -o -name "$1" -print
}

# GitHub Actions
if [ -d ".github/workflows" ]; then
  add_dependabot_ecosystem "github-actions" "/" "actions-dependencies"
fi

# Python: requirements.txt, pyproject.toml, Pipfile
python_dirs=$( (filtered_find "requirements.txt"; filtered_find "pyproject.toml"; filtered_find "Pipfile") \
  | while IFS= read -r file; do dirname "$file"; done \
  | sed 's|^\./||' | sort -u )

if [ -n "$python_dirs" ]; then
  echo "$python_dirs" | while IFS= read -r dir; do
    [[ "$dir" == "." ]] && dir=""
    add_dependabot_ecosystem "pip" "/$dir" "python-dependencies"
  done
elif filtered_find "*.py" | grep -q .; then
  echo "Found .py files but no recognised dependency file. Adding pip job at root."
  add_dependabot_ecosystem "pip" "/" "python-dependencies"
fi

# npm/Yarn: package.json
if filtered_find "package.json" | grep -q .; then
  filtered_find "package.json" | while IFS= read -r pkg_path; do
    dir=$(dirname "$pkg_path" | sed 's|^\./||')
    [[ "$dir" == "." ]] && dir=""
    add_dependabot_ecosystem "npm" "/$dir" "js-dependencies"
  done
fi

# Maven: pom.xml
if filtered_find "pom.xml" | grep -q .; then
  filtered_find "pom.xml" | while IFS= read -r pom_path; do
    dir=$(dirname "$pom_path" | sed 's|^\./||')
    [[ "$dir" == "." ]] && dir=""
    add_dependabot_ecosystem "maven" "/$dir" "maven-dependencies"
  done
fi

# Docker: Dockerfile variants
if filtered_find "Dockerfile*" | grep -q .; then
  filtered_find "Dockerfile*" | while IFS= read -r docker_path; do
    dir=$(dirname "$docker_path" | sed 's|^\./||')
    [[ "$dir" == "." ]] && dir=""
    add_dependabot_ecosystem "docker" "/$dir" "docker-dependencies"
  done
fi

echo "Proposed Dependabot configuration based on repository contents written to: $output_file"
echo "Review the file and rename to .github/dependabot.yml to activate."
