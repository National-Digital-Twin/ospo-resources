**Repository:** `ospo-resources`  
**SPDX-License-Identifier:** `Apache-2.0 AND OGL-UK-3.0` 

# Dependabot configuration helper script

This script has been developed to assist with configuring Dependabot based on the contents of a repository. It is an executable Bash script and must be run in a Linux environment.

The script generates a proposed configuration that uses [groups](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/optimizing-pr-creation-version-updates) to reduce the number of pull requests opened for a given ecosystem. This is beneficial for Dependabot pull requests, as it:

- Lowers the number of GitHub Action minutes consumed (which helps reduce the carbon footprint),
- Prevents an unmanageable number of pull requests from being raised, and
- Allows patches to be applied and tested together via CI pipelines.

Before running the script, ensure it has the appropriate execution permissions by running:

```bash
chmod +x dependabot-configuration-helper.sh
```

Once the script has been granted execution permissions, you can run it using the command:

```bash
./dependabot-configuration-helper.sh
```

The script assumes the use of GitFlow and defaults the target branch for Dependabot pull requests to develop. However, when the script is run, you will be prompted to confirm or change this value.

This script is intended to support Dependabot configuration by applying a set of suggested defaults. It is *not* a substitute for thoughtful review. You should verify that the generated configuration is consistent with the package manager ecosystems used in your repository, or adjust as required to your team's requirements.

## Public Funding Acknowledgment  
This repository has been developed with public funding as part of the National Digital Twin Programme (NDTP), a UK Government initiative. NDTP, alongside its partners, has invested in this work to advance open, secure, and reusable digital twin technologies for any organisation, whether from the public or private sector, irrespective of size.  

## License  
This repository contains both source code and documentation, which are covered by different licenses:  
- **Code:** Originally developed by the National Digital Twin Programme Open-Source Program Office for the National Digital Twin Programme. Licensed under the [Apache License 2.0](../../LICENSE.md).  
- **Documentation:** Licensed under the [Open Government Licence v3.0](../../OGL_LICENCE.md).  
See `LICENSE.md`, `OGL_LICENCE.md`, and `NOTICE.md` for details.  

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