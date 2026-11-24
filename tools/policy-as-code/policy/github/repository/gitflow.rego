# SPDX-License-Identifier: Apache-2.0
# © Crown Copyright 2026. This work has been developed by the National Digital Twin Programme and is legally
# attributed to the UK's Department for Business, Innovation, Science and Trade (BIST) as the governing entity.

# METADATA
# organizations:
# - National Digital Twin Programme
# title: GitFlow Develop Branch Policy
# description: Require repositories using main as their default branch to have a develop branch, unless centrally exempted.
package github.repository

import data.repository

# METADATA
# description: Determine whether the repository has a centrally approved exemption.
is_exempt if {
	# JSON files loaded from the policy directory contribute keys at the directory's data path.
	# Regal cannot resolve JSON data; looking up the whole data tree causes OPA recursion.
	# regal ignore:unresolved-reference
	is_repository_exempt(repository.repositoryName, data.github.repository.repositories)
}

# METADATA
# description: Match repository names exactly against the approved exemptions.
is_repository_exempt(name, repositories) if {
	some candidate in repositories
	name == candidate
}

# METADATA
# description: Require a develop branch for repositories using main as their default branch, unless exempted.
deny contains "GitFlow repository must have a 'develop' branch" if {
	repository.defaultBranch == "main"
	repository.hasDevelopBranch == false
	not is_exempt
}
