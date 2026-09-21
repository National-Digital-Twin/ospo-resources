#!/usr/bin/env bash

# SPDX-License-Identifier: Apache-2.0
# © Crown Copyright 2026. This work has been developed by the National Digital Twin Programme and is legally 
# attributed to the UK's Department for Business, Innovation, Science and Trade (BIST) as the governing entity.

# Enables the repository-level Allow auto-merge setting on all GitHub repositories in an organisation.
# Requires Bash and GitHub CLI (gh), authenticated with access to all target
# repositories and permission to update repository settings. Fine-grained
# tokens need repository Administration: write permission.
# Usage: bash enable-org-auto-merge.sh ORGANISATION [--dry-run]
# This does not enable auto-merge on individual pull requests (it just enables the repository setting).

set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 ORGANISATION [--dry-run]" >&2
  exit 2
fi
org=$1
mode=${2:-}
if [[ ! "$org" =~ ^[A-Za-z0-9][A-Za-z0-9-]*$ ]] || [[ -n "$mode" && "$mode" != --dry-run ]]; then
  echo "Invalid organisation or option. Usage: $0 ORGANISATION [--dry-run]" >&2
  exit 2
fi
command -v gh >/dev/null || { echo "Install GitHub CLI (gh) first." >&2; exit 1; }

# Complete pagination before changing any settings; listing failures abort.
repos=$(gh api --hostname github.com --method GET --paginate \
  "orgs/$org/repos?type=all&per_page=100" \
  --jq '.[] | [.full_name, .archived, .disabled] | @tsv')

updated=0
skipped=0
failed=0
planned=0
while IFS=$'\t' read -r repo archived disabled; do
  [[ -n "$repo" ]] || continue
  if [[ "$archived" == true || "$disabled" == true ]]; then
    echo "SKIP: $repo (archived or disabled)"
    skipped=$((skipped + 1))
    continue
  fi
  if [[ "$mode" == --dry-run ]]; then
    echo "WOULD ENABLE: $repo"
    planned=$((planned + 1))
    continue
  fi
  if enabled=$(gh api --hostname github.com --method PATCH "repos/$repo" \
    -F allow_auto_merge=true --jq '.allow_auto_merge'); then
    if [[ "$enabled" == true ]]; then
      echo "ENABLED: $repo"
      updated=$((updated + 1))
    else
      echo "FAILED: $repo (API did not confirm auto-merge enabled)" >&2
      failed=$((failed + 1))
    fi
  else
    echo "FAILED: $repo (see API error above)" >&2
    failed=$((failed + 1))
  fi
done <<< "$repos"

echo "Summary: enabled=$updated skipped=$skipped failed=$failed dry-run=$planned"
echo "Coverage is limited to repositories visible to your authenticated account/token."
[[ "$failed" -eq 0 ]]
