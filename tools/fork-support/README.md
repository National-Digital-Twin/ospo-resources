# README

**Repository:** `ospo-resources`
**SPDX-License-Identifier:** `Apache-2.0 AND OGL-UK-3.0`

## Overview

This directory contains workflows and tooling to support the maintenance of forked repositories within the National Digital Twin Programme (NDTP).

Specifically, it implements the **Intermediate Sync Branch Pattern**.

## Strategy Summary: Intermediate Sync Branch Pattern

This strategy decouples the **review process** from the **merge process** to safely and intentionally bypass branch protection rules for `develop` that enforce "Squash Merges".

1. **Staging Area:** We maintain a persistent branch named `intermediate-sync` which serves as a staging area for upstream updates.
2. **Regular Syncing:** This branch is automatically kept in sync with the main development branch `develop` to ensure it is always a valid target for new changes.
3. **Merge-Based Workflow:** When synchronising with the upstream repository, Pull Requests target `intermediate-sync` instead of `develop`. This allows maintainers to review the changes in isolation and can only use the merge commit merge strategy.
4. **Automated Propagation:** Once the PR is merged into `intermediate-sync`, a privileged automation workflow detects the change and performs a standard `git merge` into `develop`. This utilises a **Merge Commit**, preserving the full history of the upstream changes, which is critical for maintaining long-term fork maintainability.

This approach ensures that while human contributors are restricted to linear squash merges (for features), the upstream synchronisation process retains the necessary privileges to preserve full commit history intact.

## The Challenge

We enforce **Squash Merge** for pull requests targetting `develop` to maintain a clean, linear history for feature development. However, synchronising a fork with its upstream repository requires a **Merge Commit** to preserve the upstream history and facilitate future merges. A standard Pull Request into `develop` would be squashed, destroying this history and making future synchronisation difficult.

## The Solution

We utilise a set of four automation workflows to handle the entire lifecycle of upstream synchronisation.

| Workflow | Triggers | Purpose | Key Actions |
| :--- | :--- | :--- | :--- |
| `fork-upstream-sync.yml` | Scheduled (Nightly), Manual | Maintains a local reference of the upstream state. | Fetches upstream default branch; Force-pushes to `upstream-mirror`. |
| `fork-upstream-sync-pr.yml` | Scheduled (Weekly), Manual | Alerts maintainers to changes and prepares a PR. | Checks for diffs; Opens PR targeting `intermediate-sync`. |
| `fork-intermediate-sync.yml` | Push to `develop` | Resets the staging area to prevent merge conflicts. | Force-pushes `develop` state to `intermediate-sync`. |
| `fork-intermediate-merge.yml` | PR Merged to `intermediate-sync` | Performs the privileged merge into protected branch. | Merges `intermediate-sync` to `develop` (standard merge); Bypasses protection rules. |

## Prerequisites

To use these workflows, your repository must meet the following criteria:

- **Fork Status:** The repository must be a fork. The workflows contain checks (`if: github.event.repository.fork == true`) and will not execute on non-forked repositories.
- **Git Flow:** The repository must use the Git Flow branching strategy with a persistent `develop` branch. These workflows are specifically designed to synchronise upstream changes into `develop`.
- **GitHub Apps:** The following GitHub Apps must be installed and configured on the repository to perform privileged actions:
  - `NDTP Repository Writer` (for git operations and merges)
  - `NDTP Pull Request Controller` (for PR management)
- **Organisation Secrets:** The repository must have scoped access to the following Organisation Secrets, which are required for authentication and performing privileged operations:
  - `NDTP_REPOSITORY_WRITER_APP_CLIENT_ID`
  - `NDTP_REPOSITORY_WRITER_APP_PRIVATE_KEY`
  - `NDTP_PULL_REQUEST_CONTROLLER_APP_CLIENT_ID`
  - `NDTP_PULL_REQUEST_CONTROLLER_APP_PRIVATE_KEY`

## Installation

These workflows are automatically installed and kept up-to-date by the `Synchronise OSPO Workflows` workflow. To enable them for your forked repository:

1. **Ensure you are in a Fork:** These workflows are designed specifically for forked repositories and will only run if the repository is detected as a fork.
2. **Opt-in via Variable:** Create a **Repository Variable** (not a Secret) named `FORK_WORKFLOWS_OPT_IN` and set its value to `true`. This variable is required to create and update the workflows.
3. **Trigger Sync:** The workflows will be synchronised the next time a Pull Request is opened or updated in your repository.

Once enabled, the workflows will appear in your `.github/workflows` directory.

## Usage for Maintainers

The synchronisation process is designed to require minimal manual intervention:

1. **Triggering the Sync:** A Pull Request syncing upstream changes is automatically created on a weekly schedule. If you need to sync immediately, you can manually trigger the **Fork - Create Upstream Sync PR** workflow from the Actions tab to generate the PR on demand.

2. **Reviewing:** Treat the upstream sync PR like any other contribution. It will automatically target the `intermediate-sync` branch, allowing you to review and test the incoming changes in isolation without affecting `develop`.

3. **Merging:** Once approved, merge the Pull Request into `intermediate-sync`. The automation will detect this specific event and immediately perform a privileged, standard merge into `develop`, preserving the full commit history of the upstream changes without you needing to take further action.

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
