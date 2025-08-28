# README  

**Repository:** `ospo-resources`  
**SPDX-License-Identifier:** `Apache-2.0 AND OGL-UK-3.0` 

## Overview

This tool provides a solution for generating and grouping Software Bill of Materials (SBOMs) for all repositories in a GitHub organisation.

It uses the GitHub Dependency Graph API to export SPDX 2.3–compliant JSON SBOM documents, and the [official SPDX Python toolkit](https://github.com/spdx/tools-python) to merge them. This enables a consolidated view of dependencies for applications that are distributed across multiple repositories.

SBOM files produced by the tool are then uploaded to the GitHub Actions workflow run as an artefact, where they can be downloaded in a single zip file.

To control how SBOMs are grouped, use the [`groups.yml`](./groups.yml) file. Each group defines a set of repositories that belong to a single logical application. For example, this might span a repository for a frontend, and one for a backend. By creating a grouped SBOM for both repositories, this provides a means to assess software dependencies across both components, providing a single central view.
 For each group, the output will include:
- A folder containing individual SBOM files for each repository
- A merged SBOM file representing the entire group

This tool also supports excluding repositories that may contain sensitive contents. To do so, a repository secret named `REPOSITORIES_TO_IGNORE` containing a comma-delimited list of repository names is used. For example, setting this value to the below would ignore the respective repositories: repo-one,repo-two,example-repo 

## Prerequisites  

- **Required Tooling:** Python 3, Pip (only required if developing enhancements for the tool) 
- **Pipeline Requirements:** The sbom-aggregation.yml workflow contained in this repository is designed for GitHub Actions.
- **Supported Kubernetes Versions:** N/A  
- **System Requirements:** N/A 

## Installation

### 1. Create a New Repository
Deposit the contents of this directory in a new GitHub repository.  
Carefully consider repository visibility:  

- **Public repositories**: GitHub Action artefacts can be viewed publicly.  
- **Private repositories**: Recommended if your organisation has many private codebases, as it avoids the need to maintain a long `REPOSITORIES_TO_IGNORE` list and prevents SBOM artefacts for private resources from being exposed.

### 2. Install a GitHub Application
As with the `synchronise-ospo-workflows` tool described in this repository's [README.md](../../../../README.md), a private GitHub application must be installed in your GitHub organisation. This is required for the action to authenticate at the organisational level.

### 3. Configure Workflow File
Adjust the [sbom-aggregation.yml](.github/workflows/sbom-aggregation.yml) workflow file:  

- Set the `ORG_NAME` environment variable to match your GitHub organisation's name.  
- (Optional) Update the cron schedule to control how often the tool runs.  
  - Default: runs every Sunday at midnight.  
  - Adjust as required to suit organisational needs.

### 4. Update Python Script
Modify the [merge_sboms.py](./merge_sboms.py) file:  

- Update the `document_namespace` field with your organisation's namespace.  
- This value will appear in the merged SPDX SBOM content.

## Public Funding Acknowledgment  
This repository has been developed with public funding as part of the National Digital Twin Programme (NDTP), a UK Government initiative. NDTP, alongside its partners, has invested in this work to advance open, secure, and reusable digital twin technologies for any organisation, whether from the public or private sector, irrespective of size.  

## License  
This repository contains both source code and documentation, which are covered by different licenses:  
- **Code:** Originally developed by the National Digital Twin Programme Open-Source Program Office for the National Digital Twin Programme. Licensed under the [Apache License 2.0](../../LICENSE.md).  
- **Documentation:** Licensed under the [Open Government Licence v3.0](../../OGL_LICENSE.md).  
See `LICENSE.md`, `OGL_LICENSE.md`, and `NOTICE.md` for details.  

## Security and Responsible Disclosure  
We take security seriously. If you believe you have found a security vulnerability in this repository, please follow our responsible disclosure process outlined in [`SECURITY.md`](../../SECURITY.md).  

## Contributing  
We welcome contributions that align with the Programme’s objectives. Please read our [`CONTRIBUTING.md`](../../CONTRIBUTING.md) guidelines before submitting pull requests.  

## Acknowledgements  
This repository has benefited from collaboration with various organisations. For a list of acknowledgments, see [`ACKNOWLEDGEMENTS.md`](../../ACKNOWLEDGEMENTS.md).  

## Support and Contact  
For questions or support, check our Issues or contact the NDTP team by emailing ndtp@businessandtrade.gov.uk.

**Maintained by the National Digital Twin Programme (NDTP).**  

© Crown Copyright 2025. This work has been developed by the National Digital Twin Programme and is legally attributed to the Department for Business and Trade (UK) as the governing entity.
