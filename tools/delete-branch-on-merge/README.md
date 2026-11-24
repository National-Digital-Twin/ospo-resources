# README

**Repository:** `ospo-resources`
**SPDX-License-Identifier:** `Apache-2.0 AND OGL-UK-3.0`

# Utility helper to enable automatic deletion of merged head branches

`enable-delete-branch-on-merge-all-repos.sh` enables the `delete_branch_on_merge` repository setting across an organisation. It does not delete branches immediately; GitHub automatically deletes eligible pull-request head branches after they are merged.

GitHub branch protection rules and repository rules can prevent protected branches from being automatically deleted. Keep those protections in place for branches that must be retained.

## Prerequisites

- Bash and [GitHub CLI](https://cli.github.com/).
- Authentication using `gh auth login` or a `GH_TOKEN` environment variable.
- Access to all target repositories and permission to update repository settings. Fine-grained tokens require repository **Administration: write** permission.

## Usage

Preview the repositories without making changes:

```bash
bash enable-delete-branch-on-merge-all-repos.sh YOUR-ORGANISATION --dry-run
```

Enable the setting:

```bash
bash enable-delete-branch-on-merge-all-repos.sh YOUR-ORGANISATION
```

Archived and disabled repositories are skipped. The script only changes the repository setting; it does not call branch-deletion APIs.
