# Changelog

**Repository:** `ospo-resources`  
**Description:** `Tracks all notable changes, version history, and roadmap toward 1.0.0 following Semantic Versioning.`  
**SPDX-License-Identifier:** `OGL-UK-3.0`  

All notable changes to this repository will be documented in this file.
This project follows **Semantic Versioning (SemVer)** ([semver.org](https://semver.org/)), using the format:

`[MAJOR].[MINOR].[PATCH]`

- **MAJOR** (`X.0.0`) – Incompatible API/feature changes that break backward compatibility.
- **MINOR** (`0.X.0`) – Backward-compatible new features, enhancements, or functionality changes.
- **PATCH** (`0.0.X`) – Backward-compatible bug fixes, security updates, or minor corrections.
- **Pre-release versions** – Use suffixes such as `-alpha`, `-beta`, `-rc.1` (e.g., `2.1.0-beta.1`).
- **Build metadata** – If needed, use `+build` (e.g., `2.1.0+20250314`).

---

## [0.96.2] – 2026-01-15

### Security

- Hardened GitHub Actions workflows by mapping user-controlled data (e.g., `github.head_ref`) to environment variables in `run` blocks to prevent potential script injection.
- Refined repository permissions in `publish-github-release.yml` by moving `contents: write` from the workflow level to specific jobs, adhering to the principle of least privilege.

## [0.96.1] – 2025-12-18

### Fixed

- Patch GitHub action versions.

## [0.96.0] – 2025-12-12

### Added

- Enhance oss-checker with detailed reporting and Job Summary generation
- Add Pull Request comment summarising oss-checker results
- Upload artifact containing oss-checker results

### Changed

- Refactored oss-checker check logic to use GitHub script.

## [0.95.0] – 2025-12-03

### Added

- Enable OSS checker conditionally for private repositories when 'oss-preparation' label is present on PRs.

## [0.94.1] – 2025-11-24

### Fixed

- Patch GitHub action versions.

## [0.94.0] – 2025-10-20

### Added

- Add deployment resources and documentation for credential scanning using [TruffleHog OSS](https://github.com/trufflesecurity/trufflehog).

## [0.93.0] – 2025-08-28

### Added

- Add solution for generating Software Bill of Materials (SBOMs) for all repositories in a GitHub organisation. Please see [sbom-aggregation](./tools/sbom-aggregation/README.md).
- Updated [README.md](./README.md) to help clarify the purpose and location of tools housed in this repository.

## [0.92.1] – 2025-08-26

### Fixed

- Minor documentation corrections and patch GitHub Actions upload and download artefact steps to v5.

## [0.92.0] – 2025-08-05

### Added

- Add solution for automated pull request labelling. Please see [pull-request-labeler.yml](./.github/workflows/pull-request-labeler.yml).

## [0.91.3] – 2025-08-05

### Fixed

- Skip PR target check if pull request is raised by Dependabot to avoid workflow hangs.

## [0.91.2] – 2025-07-28

### Fixed

- Correct how dependabot helper tool ignores semver major updates if opted out.

## [0.91.1] – 2025-07-16

### Fixed

- Minor documentation corrections.

## [0.91.0] – 2025-07-11

### Added

- Helper to generate proposed Dependabot configurations based on ecosystem groups.

### Fixed

- Skip OSPO workflow synchronisation job for pull requests raised by Dependabot.

## [0.90.0] – 2025-06-23

### Initial public release

Initial public release of National Digital Twin Programme OSPO assets.

#### Initial Features

- Addition of reusable GitHub Actions workflows.

## Future Roadmap to `1.0.0`

The `0.90.x` series is part of NDTP’s **pre-stable development cycle**, meaning:

- **Minor versions (`0.91.0`, `0.92.0`...) introduce features and improvements** leading to a stable `1.0.0`.
- **Patch versions (`0.90.1`, `0.90.2`...) contain only bug fixes and security updates**.
- **Backward compatibility is NOT guaranteed until `1.0.0`**, though NDTP aims to minimise breaking changes.

Once `1.0.0` is reached, future versions will follow **strict SemVer rules**.

---

## Versioning Policy

1. **MAJOR updates (`X.0.0`)** – Typically introduce breaking changes that require users to modify their code or configurations.
   - **Breaking changes (default rule)**: Any backward-incompatible modifications require a major version bump.
   - **Non-breaking major updates (exceptional cases)**: A major version may also be incremented if the update represents a significant milestone, such as a shift in governance, a long-term stability commitment, or substantial new functionality that redefines the project’s scope.
2. **MINOR updates (`0.X.0`)** – New functionality that is backward-compatible.
3. **PATCH updates (`0.0.X`)** – Bug fixes, performance improvements, or security patches.
4. **Dependency updates** – A **major dependency upgrade** that introduces breaking changes should trigger a **MAJOR** version bump (once at `1.0.0`).

---

## How to Update This Changelog

1. When making changes, update this file under the **Unreleased** section.
2. Before a new release, move changes from **Unreleased** to a new dated section with a version number.
3. Follow **Semantic Versioning** rules to categorise changes correctly.
4. If pre-release versions are used, clearly mark them as `-alpha`, `-beta`, or `-rc.X`.

---

**Maintained by the National Digital Twin Programme (NDTP).**

© Crown Copyright 2025. This work has been developed by the National Digital Twin Programme and is legally attributed to the Department for Business and Trade (UK) as the governing entity.

Licensed under the Open Government Licence v3.0.

For full licensing terms, see [OGL_LICENSE.md](OGL_LICENSE.md).
