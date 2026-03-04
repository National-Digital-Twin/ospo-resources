# README

**Repository:** `ospo-resources`  
**SPDX-License-Identifier:** `Apache-2.0 AND OGL-UK-3.0`

## Overview

The files in this directory are used to test and validate regular expressions for GitHub Repository Rulesets. These tests specifically target the "Restrict commit metadata" rule for the `develop` branch, ensuring that commit messages adhere to the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.

This validation is critical for the `develop` branch, which uses a "Squash and merge" strategy. Because the final squash commit message is generated at merge time, it would bypass any standard CI linting tools that might run on the PR branch.

This ruleset prevents non-compliant messages from entering the history, ensuring it remains machine-readable for automated versioning and changelog generation.

> [!IMPORTANT]
> The regular expression found within this ruleset is optimised specifically for GitHub Repository Rulesets ([RE2](https://github.com/google/re2) engine) where squash merge commit messages are used.
> 
> It is not a substitute for full commit linting. Use tools like [commitlint](https://commitlint.js.org/) or [conform](https://github.com/siderolabs/conform) for local and CI commit message validation.

## Prerequisites

### Local Environment Requirements

To run the tests locally, you will need:

- **Python 3**: The test script is written in Python.
- **pip**: To install the necessary dependencies.
- **virtualenv**: Recommended for creating an isolated Python environment.

### Local Environment Setup

1. Navigate to the directory:

   ```bash
   cd tools/conventional-commits/respoitory-ruleset
   ```

2. Create and activate a virtual environment:

   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```

3. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

## Running Tests

To execute the test suite and verify the regex pattern against valid and invalid commit messages:

```bash
pytest test_commit_regex.py
```

This will run a series of test cases defined in `test_commit_regex.py`, checking that:

- Valid Conventional Commits (e.g., `feat: ...`, `fix(api): ...`) pass the regex.
- Invalid messages (e.g., missing type, bad formatting) fail the regex.

## Importing the Ruleset

A JSON file named `conventional-commit.json` is included in this directory. This file defines the "Restrict commit metadata" rule using the regex validated by these tests.

You can import this file directly into your **Organisation** or **Repository** rulesets:

1. Go to **Settings** > **Repository** (or **Organisation**) > **Rules** > **Rulesets**.
2. Click **New ruleset** > **Import a ruleset**.
3. Upload `conventional-commit.json`.
4. Review the settings (it targets the `develop` branch by default) and save.

## Message Structure

The expected commit message structure is as follows:

```text
Subject:
<type>(<scope>): <short summary>
  │       │             │
  │       │             └─⫸ Summary in present tense. Not capitalised. No period at the end.
  │       │
  │       └─⫸ Commit Scope: Optional, e.g. (api), (parser)
  │
  └─⫸ Commit Type: build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test

Body:
<detailed description of changes made in the commit> (wrap at 72 characters)

Footer:
<any additional information, such as references or issue numbers>
```

## Regular Expression Explanation

The regular expression used to enforce the commit message format is:

```regex
^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)(\([a-z0-9-.]+\))?(!)?: [a-z](?:.*[^.\n])(\n\n[\s\S]*)?$
```

### Breakdown

| Pattern | Description |
| :--- | :--- |
| `^` | Asserts the start of the string. |
| `(build\|chore\|ci\|...\|test)` | Matches one of the allowed commit types (e.g., `feat`, `fix`). |
| `(\([a-z0-9-.]+\))?` | **Optional Scope:** Matches a scope inside parentheses (e.g., `(api)`). Allowed characters are lowercase letters, numbers, hyphens, and dots. |
| `(!)?` | **Optional Breaking Change:** Matches an optional exclamation mark `!` to indicate a breaking change. |
| `: ` | Matches the required colon and space separator. |
| `[a-z]` | **Description Start:** assert that the description must start with a lowercase letter. |
| `(?:.*[^.\n])` | **Description Body:** Matches the rest of the description line. It ensures the description does **not** end with a period `.` or newline. |
| `(\n\n[\s\S]*)?` | **Optional Body/Footer:** Matches an optional body and footer section. It must be separated from the description by a blank line (`\n\n`) and can contain any characters (`[\s\S]*`). |
| `$` | Asserts the end of the string. |

## References

- [Conventional Commits Specification](https://www.conventionalcommits.org/en/v1.0.0/)
- [Creating rulesets for a repository - Adding metadata restrictions](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/creating-rulesets-for-a-repository#adding-metadata-restrictions)
- [Creating rulesets for repositories in your organisation - Using regular expressions for commit metadata](https://docs.github.com/en/enterprise-cloud@latest/organizations/managing-organization-settings/creating-rulesets-for-repositories-in-your-organization#using-regular-expressions-for-commit-metadata)

## Public Funding Acknowledgment

This repository has been developed with public funding as part of the National Digital Twin Programme (NDTP), a UK Government initiative. NDTP, alongside its partners, has invested in this work to advance open, secure, and reusable digital twin technologies for any organisation, whether from the public or private sector, irrespective of size.

## License

This repository contains both source code and documentation, which are covered by different licenses:

- **Code:** Originally developed by the National Digital Twin Programme Open-Source Program Office for the National Digital Twin Programme. Licensed under the [Apache License 2.0](../../../LICENSE.md).
- **Documentation:** Licensed under the [Open Government Licence v3.0](../../../OGL_LICENSE.md).
See `LICENSE.md`, `OGL_LICENSE.md`, and `NOTICE.md` for details.

## Security and Responsible Disclosure

We take security seriously. If you believe you have found a security vulnerability in this repository, please follow our responsible disclosure process outlined in [`SECURITY.md`](../../SECURITY.md).

## Contributing

We welcome contributions that align with the Programme’s objectives. Please read our [`CONTRIBUTING.md`](../../CONTRIBUTING.md) guidelines before submitting pull requests.

## Acknowledgements

This repository has benefited from collaboration with various organisations. For a list of acknowledgements, see [`ACKNOWLEDGEMENTS.md`](../../ACKNOWLEDGEMENTS.md).

## Support and Contact

For questions or support, check our Issues or contact the NDTP team by emailing <ndtp@businessandtrade.gov.uk>.

**Maintained by the National Digital Twin Programme (NDTP).**

© Crown Copyright 2026. This work has been developed by the National Digital Twin Programme and is legally attributed to the Department for Business and Trade (UK) as the governing entity.
