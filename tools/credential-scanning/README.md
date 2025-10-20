# Overview
The files in this directory provide configuration and deployment resources for running the [TruffleHog OSS](https://github.com/trufflesecurity/trufflehog) open-source credential scanning solution. This offers an alternative approach for credential scanning in private repositories without the per-committer cost of GitHub Secrets Scanning. In addition, the included pre-commit hook can help catch potential credential disclosure earlier in the lifecycle, before a commit is made to source control.

## Prerequisites  

### Local Use Requirements

The pre-commit solution included in this repository requires all users have docker installed on their development environment.

### Local Use setup and use

To help avoid sensitive credentials being deposited to source control, a pre-configured git pre-commit hook has been included in this repository. You can enable this feature for a repository by copying the .githooks folder to the root of your repository. Once there, you can be register the helper by running the command `git config --global core.hooksPath .githooks/`. Alternatively, the command `make git-credential-config` can be run if Make is installed.

When staging content for a commit, files will be automatically scanned and if credentials verified, the commit will be aborted.

### GitHub Action
The [credential-scan.yml](./credential-scan.yml) file is designed for use with GitHub Actions. The only prerequisite is that your source code is managed on GitHub. To deploy this action, place the file in your repository’s `.github/workflows` directory. Alternatively, you can host a central repository and apply a repository ruleset (using the branch ruleset type), enable the “Require workflows to pass before merging” setting, and reference the `credential-scan.yml` action.

### Makefile content

A shorthand for running credential scans manually at any time is included in this solution's source. To trigger a git (verified only) scan, run the command `make credential-scan-git-verified`. Please see Makefile contents for other supported scan types.

### Filtering false positives

On issuing the `make git-credential-config` command, a `credential-scan-exclusions.txt` file will be created in the root of your repository directory (if it does not already exist). If a .gitignore file is found in the repository root, this will be used as the template with newlines removed. Regex filepaths can then be added to this file (newline separated) to filter out false positives on a git commit command being issued.

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