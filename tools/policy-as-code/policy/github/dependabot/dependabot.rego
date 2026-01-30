# SPDX-License-Identifier: Apache-2.0
# © Crown Copyright 2025. This work has been developed by the National Digital Twin Programme and is legally attributed to the Department for Business and Trade (UK) as the governing entity.

# METADATA
# organizations:
# - National Digital Twin Programme
# title: Dependabot Git Flow Target Branch Policy
# description: A set of rules to enforce target branch policies for Dependabot in Git Flow repositories
package github.dependabot

import data.repository

# METADATA
# title: Determine if repository uses Git Flow
is_git_flow if {
	repository.defaultBranch == "main"
	repository.hasDevelopBranch == true
}

# METADATA
# entrypoint: true
# description: Deny Dependabot updates that do not target the 'develop' branch in Git Flow repositories
deny contains msg if {
	is_git_flow
	some i
	package_ecosystem := input.updates[i]["package-ecosystem"]
	input.updates[i]["target-branch"] != "develop"
	msg := sprintf("Dependabot update configuration for '%v' must target 'develop'", [package_ecosystem])
}

# METADATA
# description: Deny Dependabot updates that are missing the 'target-branch' field in Git Flow repositories
deny contains msg if {
	is_git_flow
	some i
	package_ecosystem := input.updates[i]["package-ecosystem"]
	not input.updates[i]["target-branch"]
	msg := sprintf("Dependabot update configuration for '%v' is missing 'target-branch'", [package_ecosystem])
}
