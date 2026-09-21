# SPDX-License-Identifier: Apache-2.0
# © Crown Copyright 2026. This work has been developed by the National Digital Twin Programme and is legally attributed to the Department for Business and Trade (UK) as the governing entity.

# METADATA
# organizations:
# - National Digital Twin Programme
# title: Dependabot GitHub Actions Default Branch Policy
# description: Require GitHub Actions updates to omit target-branch
package github.dependabot

# METADATA
# entrypoint: true
# description: Deny GitHub Actions updates with an explicit target-branch field
deny contains msg if {
	msg := "Dependabot update configuration for 'github-actions' must omit 'target-branch' so updates target the repository default branch"

	some update in input.updates
	update["package-ecosystem"] == "github-actions"
	"target-branch" in object.keys(update)
}
