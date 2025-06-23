# README  

**Repository:** `[archetypes]`  
**Description:** `[This repository has been put together to as a template repository, to support new repository creation]`  
**SPDX-License-Identifier:** `Apache-2.0 AND OGL-UK-3.0 `  

## Overview  

This repository has been put together to support with new repository creation. When you create a new repository you can use this template, as a base to ensure you include all the standard documentation, folder structure and a few base build pipelines. 

While initially this repositories focus has been on creating a set of base template documentation files, the intent is to continue expanding this to include pipeline checks, that could help ensure documentation follows basic rules and checks through standard continuous integration (CI) validation examples in the future.   

<!--

GUIDANCE: IN PLACE OF THE ABOVE, PROVIDE THE OVERVIEW DETAILS THAT ARE RELEVANT TO THE REPOSITORY

EXAMPLE:

This repository has been put together to support with new repository creation. When you create a new repository you can use this template, as a base to ensure you include all the standard documentation, folder structure and a few base build pipelines. 

While initially this repositories focus has been on creating a set of base template documentation files, the intent is to continue expanding this to include pipeline checks, that could help ensure documentation follows basic rules and checks through standard continuous integration (CI) validation examples in the future.  
 
 -->

## Prerequisites  

As this is just a template example repository the only prerequisites are to have a github account.

<!--

GUIDANCE: IN PLACE OF THE ABOVE, PROVIDE THE PREREQUISITES THAT ARE RELEVANT TO THE REPOSITORY

EXAMPLE:

Before using this repository, ensure you have the following dependencies installed:  

- **Required Tooling:** [List required CLI tools, SDKs, or dependencies]  
- **Pipeline Requirements:** [Describe CI/CD pipeline compatibility]  
- **Supported Kubernetes Versions:** [List supported Kubernetes versions, if applicable]  
- **System Requirements:** [Minimum hardware/software requirements]  
 
 -->

## Quick Start  

> [!IMPORTANT]  
> Before using this repository, please keep in mind, these are just example files and everything has been outlined based on setting up a "new repository" and you are still expected to review any official guidance alongside using this content. If you are using these as a reference to help update an "existing repository" that may have been forked, you should also ensure original contributions are properly acknowledged, while also reflecting NDTP’s role as the maintainer and contributor of the fork as outlined by the official guidance. 

### 1. Create new Repository from Template

Create a new repository from template using the `archetypes` as the template repository

### 3. Update Repository Name

All references throughout the files, that refer to the repository name `archetypes` should be replaced with the new target repository name

### 3. Update/Remove all GUIDANCE/EXAMPLE sections

Throughout all the `.md` files are some `GUIDANCE` blocks sometimes also including `EXAMPLE` sections similar that below. 

```md
<!-- 
GUIDANCE: 
 -->
```
These blocks don't appear on previews, the are just intended to help support updating the markdown file content when you first create a new repository and should be fully removed after content has been updated. 

### 4. Pull Requests

Included in this repository is an example [PULL_REQUEST_TEMPLATE.md](./.github/PULL_REQUEST_TEMPLATE.md), which can be used to help prompt specific content to include in pull requests by contributors. 

There are also two basic example rulesets [pr_ruleset_example_default_main.json](./.github/codepolicyexamples/pr_ruleset_example_default_main.json) and [pr_ruleset_example_develop.json](./.github/codepolicyexamples/pr_ruleset_example_default_main.json) that can be used to configure a minimal basic policy for you pull requests. The folder containing these files should be removed on any repositories as these are just for reference examples only. 

<!--

GUIDANCE: IN PLACE OF THE ABOVE, PROVIDE QUICK START STEPS THAT ARE RELEVANT TO THE REPOSITORY

EXAMPLE:

Follow these steps to get started quickly with this repository. For detailed installation, configuration, and deployment, refer to the relevant MD files.  

### 1. Download and Build  
```sh  
git clone https://github.com/[archetypes].git  
cd [archetypes]  
```

### 2. Run Build Version  
```sh  
[build-command] --version  
```

### 3. Full Installation  
Refer to [INSTALLATION.md](./INSTALLATION.md) for detailed installation steps, including required dependencies 
and setup configurations.  


### 4. Uninstallation  
For steps to remove this repository and its dependencies, see [UNINSTALL.md](./UNINSTALL.md).  

 -->

 <!--

GUIDANCE: UPDATE THE FOLLOWING SECTIONS WITH WITH REPOSITORY SPECIFIC DETAIL 

Installation
Add setup instructions, dependencies, or package managers.

Configuration 
List any required settings, such as environment variables.

Build
Include instructions to compile/build the project.

Usage
Explain how the repository should be used, including examples.

Example
Provide a sample command, API request, or function call.

Modules
List key components included in the repository

Run
Indicate whether the repository contains executable code, debugging tools, or is a
dependency for other projects

-->

## Features  

- **Base Document Templates** 
- **Pull Request Template Example** 
- **Dependabot Example** 
- **Default Repository Structure Example** 

<!--

GUIDANCE: IN PLACE OF THE ABOVE, PROVIDE FEATURE DETAILS THAT ARE RELEVANT TO THE REPOSITORY

EXAMPLE:

Include a brief list of key features provided by this repository. These should highlight what makes the project valuable to users and contributors. Examples of features might include:  
- **Core functionality** (e.g., "Supports secure and federated data-sharing")  
- **Key integrations** (e.g., "Provides REST and GraphQL API interfaces")  
- **Scalability & performance** (e.g., "Optimized for high-throughput environments")  
- **Modularity** (e.g., "Designed with a plugin-based architecture for extensibility")  

 -->

<!--

GUIDANCE: IF THIS REPOSITORY USES AN API, INCLUDE THE SECTION BELOW WITH THE DETAILS RELEVANT TO THE REPOSITORY
 
## API Documentation  
[If this repository exposes an API, link to API documentation or describe the endpoints.]  

 -->

## Public Funding Acknowledgment  
This repository has been developed with public funding as part of the National Digital Twin Programme (NDTP), a UK Government initiative. NDTP, alongside its partners, has invested in this work to advance open, secure, and reusable digital twin technologies for any organisation, whether from the public or private sector, irrespective of size.  

## License  
This repository contains both source code and documentation, which are covered by different licenses:  
- **Code:** Originally developed by [Original Developer, if applicable], now maintained by National Digital Twin Programme. Licensed under the [Apache License 2.0](./LICENSE.md).  
- **Documentation:** Licensed under the [Open Government Licence v3.0](./OGL_LICENCE.md).  
See `LICENSE.md`, `OGL_LICENCE.md`, and `NOTICE.md` for details.  

## Security and Responsible Disclosure  
We take security seriously. If you believe you have found a security vulnerability in this repository, please follow our responsible disclosure process outlined in [`SECURITY.md`](./SECURITY.md).  

## Contributing  
We welcome contributions that align with the Programme’s objectives. Please read our [`CONTRIBUTING.md`](./CONTRIBUTING.md) guidelines before submitting pull requests.  

## Acknowledgements  
This repository has benefited from collaboration with various organisations. For a list of acknowledgments, see [`ACKNOWLEDGEMENTS.md`](./ACKNOWLEDGEMENTS.md).  

## Support and Contact  
For questions or support, check our Issues or contact the NDTP team on ndtp@businessandtrade.gov.uk.

**Maintained by the National Digital Twin Programme (NDTP).**  

© Crown Copyright 2025. This work has been developed by the National Digital Twin Programme and is legally attributed to the Department for Business and Trade (UK) as the governing entity.
