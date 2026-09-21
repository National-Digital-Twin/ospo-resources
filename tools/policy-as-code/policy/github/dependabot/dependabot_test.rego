# SPDX-License-Identifier: Apache-2.0
# © Crown Copyright 2026. This work has been developed by the National Digital Twin Programme and is legally attributed to the UK's Department for Business, Innovation, Science and Trade (BIST) as the governing entity.
package github.dependabot_test

import data.github.dependabot

expected_message := "Dependabot update configuration for 'github-actions' must omit 'target-branch' so updates target the repository default branch"

# Helper to check if deny is empty
no_violations if {
	count(dependabot.deny) == 0
}

test_denies_github_actions_targeting_develop if {
	mock_input := {"updates": [{
		"package-ecosystem": "github-actions",
		"target-branch": "develop",
	}]}

	dependabot.deny == {expected_message} with input as mock_input
}

test_denies_github_actions_targeting_main if {
	mock_input := {"updates": [{
		"package-ecosystem": "github-actions",
		"target-branch": "main",
	}]}

	dependabot.deny == {expected_message} with input as mock_input
}

test_denies_github_actions_with_empty_target_branch if {
	mock_input := {"updates": [{
		"package-ecosystem": "github-actions",
		"target-branch": "",
	}]}

	dependabot.deny == {expected_message} with input as mock_input
}

test_denies_github_actions_with_null_target_branch if {
	mock_input := {"updates": [{
		"package-ecosystem": "github-actions",
		"target-branch": null,
	}]}

	dependabot.deny == {expected_message} with input as mock_input
}

test_allows_github_actions_without_target_branch if {
	mock_input := {"updates": [{
		"package-ecosystem": "github-actions",
	}]}

	no_violations with input as mock_input
}

test_allows_other_ecosystems_with_target_branch if {
	mock_input := {"updates": [
		{
			"package-ecosystem": "npm",
			"target-branch": "develop",
		},
		{
			"package-ecosystem": "pip",
			"target-branch": "main",
		},
	]}

	no_violations with input as mock_input
}

test_allows_other_ecosystems_without_target_branch if {
	mock_input := {"updates": [
		{"package-ecosystem": "npm"},
		{"package-ecosystem": "pip"},
	]}

	no_violations with input as mock_input
}

test_multiple_updates_with_mixed_compliance if {
	mock_input := {"updates": [
		{
			"package-ecosystem": "github-actions",
			"directory": "/",
		},
		{
			"package-ecosystem": "github-actions",
			"directory": "/additional",
			"target-branch": "develop",
		},
		{
			"package-ecosystem": "npm",
			"target-branch": "develop",
		},
	]}

	dependabot.deny == {expected_message} with input as mock_input
}

test_multiple_updates_all_compliant if {
	mock_input := {"updates": [
		{"package-ecosystem": "github-actions"},
		{
			"package-ecosystem": "npm",
			"target-branch": "develop",
		},
		{"package-ecosystem": "pip"},
	]}

	no_violations with input as mock_input
}