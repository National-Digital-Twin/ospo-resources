# README

**Repository:** `ospo-resources`
**SPDX-License-Identifier:** `Apache-2.0 AND OGL-UK-3.0`

## Overview

This directory contains the Policy as Code (PaC) definitions used to enforce governance, security, and quality standards across repositories within the National Digital Twin Programme (NDTP).

These policies are executed using [Conftest](https://www.conftest.dev/), a utility for testing configuration files using the [Open Policy Agent (OPA)](https://www.openpolicyagent.org/) Rego query language.

The policies defined here are automatically executed as part of the automated `oss-checker` workflow. This ensures that repositories are continuously validated against organisational standards, providing immediate feedback to contributors via automated compliance checks on Pull Requests.

## Prerequisites

To develop, test, or run these policies locally, you will need the following tools installed:

- **[Conftest](https://www.conftest.dev/install/)**: The test runner used to execute the policies against configuration files.
- **[Open Policy Agent (OPA)](https://www.openpolicyagent.org/docs/latest/#running-opa)** (Optional): Useful for advanced policy development and debugging.
- **[Open Policy Agent (VS Code)](https://marketplace.visualstudio.com/items?itemName=tsandall.opa)** (Optional): Provides language server support, linting, formatting, and other helpful features for checking policies directly in the editor.

## Directory Structure

We use a namespaced directory structure to organise policies. Each subdirectory represents a namespace (or package path), which helps isolate rules and prevents collisions.

```text
# Directory structure                  # Namespace (Package Path)
tools/policy-as-code/
├── policy/                            # Root for all policy definitions
│   ├── github/                        # Namespace: github
│   │   ├── dependabot/                # Namespace: github.dependabot
│   │   │   ├── dependabot.rego
│   │   │   └── dependabot_test.rego
│   │   └── required_files/            # Namespace: github.required_files (Future example)
│   │       ├── checks.rego
│   │       └── checks_test.rego
└── README.md
```

*Note: In this repository, we colocate tests alongside the policy files.*

## Developing Policies

Policies are written in **Rego**. Conftest looks for `deny`, `violation`, or `warn` rules.

### Namespaces and Package Paths

We adopt the [OPA Regal](https://www.openpolicyagent.org/projects/regal/) linting standards to ensure consistency across all policies. This includes the [`directory-package-mismatch`](https://www.openpolicyagent.org/projects/regal/rules/idiomatic/directory-package-mismatch) rule for package naming.

The package name **MUST** match the file's directory path relative to the policy root.

For a policy located at `policy/github/dependabot/dependabot.rego`, the package declaration **MUST** be:

```rego
package github.dependabot
```

### Writing a New Policy

#### Example

```rego
# Package matches the folder structure: policy/repository/required_files/
package repository.required_files

# Deny if the required file 'CODE_OF_CONDUCT.md' is missing
deny contains msg if {
    # Logic to check for file existence would go here
    # This often depends on how input is structured (e.g. combined file list)
    not input_has_file("CODE_OF_CONDUCT.md")
    msg := "Repository is missing CODE_OF_CONDUCT.md"
}

# Helper function
input_has_file(filename) if {
    # Check logic...
    true
}
```

## Writing Unit Tests

> [!IMPORTANT]
> All policies **MUST** be accompanied by unit tests that provide appropriate coverage. This includes testing both compliant `allow` and non-compliant `deny` scenarios to ensure rules trigger correctly and avoid false positives.

### Test Package Naming

The test package should be the policy package name suffixed with `_test` as described in the OPA Regal linting standards [`file-missing-test-suffix`](https://www.openpolicyagent.org/projects/regal/rules/testing/file-missing-test-suffix) and [`test-outside-test-package`](https://www.openpolicyagent.org/projects/regal/rules/testing/test-outside-test-package) rules e.g.

`package repository.required_files_test`.

### Importing the Policy

You must import the policy data to test its rules e.g.

`import data.repo.required_files`

#### Example

```rego
# policy/repo/required_files/checks_test.rego
package repo.required_files_test

# Import the package being tested
import data.repo.required_files

# Test: Expect denial when file is missing
test_deny_missing_code_of_conduct if {
    # Mock input where file is missing
    mock_input := {"files": ["README.md", "LICENSE"]}
    
    # Check that 'deny' set contains the expected message
    # Note: We access the rule via the imported namespace
    count(required_files.deny) > 0 with input as mock_input
}
```

## Running Checks Locally

### Verification (Unit Tests)

To run the unit tests and verify the logic of your policies:

```bash
# Verify all policies
conftest verify --policy policy/

# Verify a specific namespace (by pointing to the subdirectory)
conftest verify --policy policy/github/dependabot/
```

### Testing against files (Execute Policies Locally)

To run the policies against the real files:

```bash
# Example: Testing dependabot config
conftest test .github/dependabot.yml --policy policy/

# Example: Testing a specific namespace against a file
conftest test .github/dependabot.yml --policy policy/ --namespace github.dependabot
```

## Public Funding Acknowledgement

This repository has been developed with public funding as part of the National Digital Twin Programme (NDTP), a UK Government initiative. NDTP, alongside its partners, has invested in this work to advance open, secure, and reusable digital twin technologies for any organisation, whether from the public or private sector, irrespective of size.

## Licence

This repository contains both source code and documentation, which are covered by different licences:

- **Code:** Originally developed by the National Digital Twin Programme Open-Source Programme Office for the National Digital Twin Programme. Licensed under the [Apache License 2.0](../../LICENSE.md).
- **Documentation:** Licensed under the [Open Government Licence v3.0](../../OGL_LICENSE.md).
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

© Crown Copyright 2025. This work has been developed by the National Digital Twin Programme and is legally attributed to the Department for Business and Trade (UK) as the governing entity.
