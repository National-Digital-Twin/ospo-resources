# Overview
The files in this directory provide configuration and deployment resources for running the [TruffleHog OSS](https://github.com/trufflesecurity/trufflehog) open-source credential scanning solution. This offers an alternative approach for credential scanning in private repositories without the per-committer cost of GitHub Secrets Scanning. In addition, the included pre-commit hook can help catch potential credential disclosure earlier in the lifecycle, before a commit is made to source control.

## Prerequisites  

### Local Environment Requirements

The pre-commit solution included in this repository requires all users have [docker](https://www.docker.com/get-started/) installed on their local development environment.

### Local Environment Setup

To help avoid sensitive credentials being deposited to source control, a pre-configured git pre-commit hook (used for local environments only) that runs a credential scan using the official TruffleHog OSS docker image has been included in this repository. 

#### Registering the .githook

You can enable this feature for a repository by copying the [.githooks](.githooks) folder to the root of your repository. Once there, you can register the helper by running the command `git config --global core.hooksPath .githooks/`. Alternatively, the command `make git-credential-config` can be run if Make is installed.

When staging content for a commit, files will be automatically scanned and if credentials verified, the commit will be aborted.

#### Running manually using Make

A Makefile that includes a set of named commands for running credential scans (using the TruffleHog OSS docker image) manually at any time is included in this solution's source.

If `Make` is installed, run the command `make credential-scan-verified`. Please see [Makefile](./Makefile) contents for other supported scan types.

#### Testing the installation

Once the tool has been registered, to test if it is working, create a file called `creds.txt` and add the content found at [test keys](https://github.com/trufflesecurity/test_keys/blob/main/keys). Once the file has been created, run the command `make credential-scan-unverified`. If the tool has been registered correctly, you will receive an ouput saying "Found verified result", with details of the credential placed in the `creds.txt` file.

To test the pre-commit hook, stage the file as a commit to github. When running the git commit command, the same output should be observed and the commit will be cancelled. A clean scan will allow a commit to continue as normal.

#### Filtering false positives

On issuing the `make git-credential-config` command, a `credential-scan-exclusions.txt` file will be created in the root of your repository directory (if it does not already exist). This file can be populated using the same syntax as .gitignore files to intentionally exclude false positives when running local scans using the unverified flag.


### GitHub Action
The [credential-scan.yml](./credential-scan.yml) file is designed for use with GitHub Actions. The only prerequisite is that your source code is managed on GitHub. To deploy this action, place the file in your repository’s `.github/workflows` directory. Alternatively, you can host a central repository and apply a repository ruleset (using the branch ruleset type), enable the "Require workflows to pass before merging" setting, and reference the `credential-scan.yml` action.

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
