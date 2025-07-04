# README  

**Repository:** `ospo-resources`  
**Description:** `This repository contains technical resources created by the NDTP Open Source Project Office (OSPO) for programme contributors.`  
**SPDX-License-Identifier:** `Apache-2.0 AND OGL-UK-3.0 `  

## Overview  

This repository contains technical resources produced by the NDTP Open Source Project Office (OSPO) for programme contributors. It includes reusable GitHub Actions workflows and other resources to support OSPO’s technical needs and ensure consistency across programme repositories.

## Prerequisites

The contents maintained in this repository are designed for use with GitHub.

### Notes for external use

If you wish to use these materials outside of the `National-Digital-Twin` organisation, please note that repository names used in the GitHub Actions files will require adjustment.

## Using the `synchronise-ospo-workflows` GitHub Action

To use the `synchronise-ospo-workflows` GitHub Action, a private GitHub application must be installed in your GitHub organisation. This is because the workflow requires `workflow:write` permissions to add content to the `.github/workflows` directory, which cannot currently be achieved using the [`GITHUB_TOKEN`](https://docs.github.com/en/actions/how-to/choose-the-permissions-for-the-github-token#permissions-for-the-github_token) authorisation context.

Guidance on installing a GitHub application can be found here:  
[Installing your own GitHub App](https://docs.github.com/en/apps/using-github-apps/installing-your-own-github-app)

### Required GitHub App permissions

The GitHub application must have the following **repository permissions**:

1. `contents:read`  
2. `contents:write`  
3. `workflows:read`  
4. `workflows:write`

### Setting up secrets

Once your GitHub application has been created, the `synchronise-ospo-workflows` action must be able to assume the identity of the application. To do this, two repository secrets are required:

- `OSPO_WORKFLOW_APP_ID`  
- `OSPO_WORKFLOW_PRIVATE_KEY`

For ease of administration, these secrets can be set once as **organisation-level secrets**, with access delegated to trusted repositories, rather than adding them to each repository individually.

Guidance on managing organisation secrets is available here:  
[Creating and managing organisation secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-organization-secrets)

### Granting repository access

Assign repository access to your GitHub application for each trusted repository where you want to use the `synchronise-ospo-workflows` workflow.

### Organisational repository ruleset

To trigger the `synchronise-ospo-workflows` workflow when pull requests are made in repositories within your organisation, a [repository ruleset](https://docs.github.com/en/enterprise-cloud@latest/organizations/managing-organization-settings/creating-rulesets-for-repositories-in-your-organization) must be created with the following settings enabled:

- **Require workflows to pass before merging**  
- **Do not require workflows on creation**

The workflow configuration section of the ruleset should reference the `synchronise-ospo-workflows` workflow found in the repository housing these assets.

Because the status check is marked as *required* at the organisation level, the workflow will be triggered automatically - unlike with standard repository rulesets.

## Pull Requests

Any proposed changes to the main branch must be navigated via a Pull Request, which has been enforced using branch protection policies. Pull requests must include the details in the [PULL_REQUEST_TEMPLATE.md](./.github/PULL_REQUEST_TEMPLATE.md) file.

## Features  

- **Reusable GitHub Actions for utility tasks** 

## Public Funding Acknowledgment  
This repository has been developed with public funding as part of the National Digital Twin Programme (NDTP), a UK Government initiative. NDTP, alongside its partners, has invested in this work to advance open, secure, and reusable digital twin technologies for any organisation, whether from the public or private sector, irrespective of size.  

## License  
This repository contains both source code and documentation, which are covered by different licenses:  
- **Code:** Originally developed by the National Digital Twin Programme Open-Source Project Office for the National Digital Twin Programme. Licensed under the [Apache License 2.0](./LICENSE.md).  
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
