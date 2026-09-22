# README

**Repository:** `ospo-resources`  
**SPDX-License-Identifier:** `Apache-2.0 AND OGL-UK-3.0`

# Utility helper to enable auto-merge across an organisation

`enable-auto-merge-all-repos.sh` bulk enables the **Allow auto-merge** repository setting for all repositories in a GitHub organisation. This is needed to support capabilities such as automatically merging dependabot pull requests, like that seen in [auto-merge-dependabot-pull-requests.yml](../../.github/workflows/auto-merge-dependabot-pull-requests.yml).

## Prerequisites

- Bash and [GitHub CLI](https://cli.github.com/).
- Authentication using `gh auth login` or a `GH_TOKEN` environment variable.
- Access to all target repositories and permission to update their settings. Fine-grained tokens require repository **Administration: write** permission.

## Usage

Preview the repositories without making changes:

```bash
bash enable-auto-merge-all-repos.sh YOUR-ORGANISATION --dry-run
```

Enable the setting:

```bash
bash enable-auto-merge-all-repos.sh YOUR-ORGANISATION
```

The script enables the repository setting only. Auto-merge must still be enabled on individual pull requests, which remain subject to the repository's merge requirements.
