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