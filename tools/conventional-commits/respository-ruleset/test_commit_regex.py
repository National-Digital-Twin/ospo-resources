# SPDX-License-Identifier: Apache-2.0
# © Crown Copyright 2026. This work has been developed by the National Digital Twin Programme and is legally attributed to the Department for Business and Trade (UK) as the governing entity.

import pytest
import re2
from textwrap import dedent

# The Regex for GitHub Ruleset (RE2 compatible)
REGEX_PATTERN = r'^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)(\([a-z0-9-.]+\))?(!)?: [a-z](?:.*[^.\n])(\n\n[\s\S]*)?$'

# --- Test Data ---

VALID_COMMITS = [
    "feat: add new feature",
    "fix(api): handle timeout",
    "chore!: drop node 12",
    "docs: update readme",
    "style: fix linting issues",
    dedent("""\
        fix: fix bug

        Detailed body text here.\
    """),
    dedent("""\
        feat: title

        Body with
        multiple lines.\
    """),
    dedent("""\
        feat: add new search endpoint

        This adds a new endpoint to search for users by name.

        Refs: OSPO-88\
    """),
    # Conventional Commits Examples from https://www.conventionalcommits.org/en/v1.0.0/#examples
    dedent("""\
        feat: allow provided config object to extend other configs

        BREAKING CHANGE: `extends` key in config file is now used for extending other config files\
    """),
    "feat!: send an email to the customer when a product is shipped",
    "feat(api)!: send an email to the customer when a product is shipped",
    dedent("""\
        chore!: drop support for Node 6

        BREAKING CHANGE: use JavaScript features not available in Node 6.\
    """),
    "docs: correct spelling of CHANGELOG",
    "feat(lang): add Polish language",
    dedent("""\
        fix: prevent racing of requests

        Introduce a request id and a reference to latest request. Dismiss
        incoming responses other than from latest request.

        Remove timeouts which were used to mitigate the racing issue but are
        obsolete now.

        Reviewed-by: Z
        Refs: #123\
    """),
    dedent("""\
        revert: let us never again speak of the noodle incident

        Refs: 676104e, a215868\
    """),
]

INVALID_COMMITS = [
    ("Update readme", "Missing type"),
    ("feat: Add new feature", "Capitalized description"),
    ("feat: add new feature.", "Ends with period"),
    ("feat: a", "Single character description"),
    ("feat: a.", "Single character description with period"),
    (dedent("""\
        feat: title
        Body\
    """), "Missing blank line before body"),
    ("feat : bad spacing", "Space before colon"),
    ("feat:  double space", "Double space after colon"),
    ("random: type unknown", "Invalid type"),
]

# --- Tests ---

@pytest.mark.parametrize("commit_msg", VALID_COMMITS)
def test_valid_commits(commit_msg):
    """Verifies that valid commit messages match the regex pattern."""
    # re2.match checks for a match at the beginning of the string
    # Since our regex starts with ^, match() is appropriate.
    # Note: re2.match returns a match object (truthy) or None (falsy)
    assert re2.match(REGEX_PATTERN, commit_msg), f"Failed to match valid commit: {commit_msg}"

@pytest.mark.parametrize("commit_msg, reason", INVALID_COMMITS)
def test_invalid_commits(commit_msg, reason):
    """Verifies that invalid commit messages do NOT match the regex."""
    assert not re2.match(REGEX_PATTERN, commit_msg), f"Incorrectly matched invalid commit ({reason}): {commit_msg}"
