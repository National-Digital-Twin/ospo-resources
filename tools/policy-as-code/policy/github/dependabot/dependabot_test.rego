# SPDX-License-Identifier: Apache-2.0
# © Crown Copyright 2026. This work has been developed by the National Digital Twin Programme and is legally
# attributed to the UK's Department for Business, Innovation, Science and Trade (BIST) as the governing entity.
package github.dependabot_test

import data.github.dependabot

expected_message := "Dependabot update configuration for 'github-actions' must omit 'target-branch' so updates target the repository default branch"
valid_groups := {"versions": {}}
git_flow_repo := {"defaultBranch": "main", "hasDevelopBranch": true}

# Helper to check if deny is empty
no_violations if {
	count(dependabot.deny) == 0
}

test_denies_github_actions_targeting_develop if {
	mock_input := {"updates": [{
		"package-ecosystem": "github-actions",
		"target-branch": "develop",
		"groups": valid_groups,
	}]}

	dependabot.deny == {expected_message} with input as mock_input
}

test_denies_github_actions_targeting_main if {
	mock_input := {"updates": [{
		"package-ecosystem": "github-actions",
		"target-branch": "main",
		"groups": valid_groups,
	}]}

	dependabot.deny == {expected_message} with input as mock_input
}

test_denies_github_actions_with_empty_target_branch if {
	mock_input := {"updates": [{
		"package-ecosystem": "github-actions",
		"target-branch": "",
		"groups": valid_groups,
	}]}

	dependabot.deny == {expected_message} with input as mock_input
}

test_denies_github_actions_with_null_target_branch if {
	mock_input := {"updates": [{
		"package-ecosystem": "github-actions",
		"target-branch": null,
		"groups": valid_groups,
	}]}

	dependabot.deny == {expected_message} with input as mock_input
}

test_allows_github_actions_without_target_branch if {
	mock_input := {"updates": [{
		"package-ecosystem": "github-actions",
		"groups": valid_groups,
	}]}

	no_violations with input as mock_input
}

test_allows_other_ecosystems_with_target_branch if {
	mock_input := {"updates": [
		{
			"package-ecosystem": "npm",
			"target-branch": "develop",
			"groups": valid_groups,
		},
		{
			"package-ecosystem": "pip",
			"target-branch": "main",
			"groups": valid_groups,
		},
	]}

	no_violations with input as mock_input
}

test_allows_other_ecosystems_without_target_branch if {
	mock_input := {"updates": [
		{"package-ecosystem": "npm", "groups": valid_groups},
		{"package-ecosystem": "pip", "groups": valid_groups},
	]}

	no_violations with input as mock_input
}

test_multiple_updates_with_mixed_compliance if {
	mock_input := {"updates": [
		{
			"package-ecosystem": "github-actions",
			"directory": "/",
			"groups": valid_groups,
		},
		{
			"package-ecosystem": "github-actions",
			"directory": "/additional",
			"target-branch": "develop",
			"groups": valid_groups,
		},
		{
			"package-ecosystem": "npm",
			"target-branch": "develop",
			"groups": valid_groups,
		},
	]}

	dependabot.deny == {expected_message} with input as mock_input
}

test_multiple_updates_all_compliant if {
	mock_input := {"updates": [
		{"package-ecosystem": "github-actions", "groups": valid_groups},
		{
			"package-ecosystem": "npm",
			"target-branch": "develop",
			"groups": valid_groups,
		},
		{"package-ecosystem": "pip", "groups": valid_groups},
	]}

	no_violations with input as mock_input
}

test_denies_non_actions_targeting_main_in_git_flow if {
	mock_input := {"updates": [{"package-ecosystem": "npm", "target-branch": "main", "groups": valid_groups}]}
	dependabot.deny == {"Dependabot update configuration for 'npm' must target 'develop'"} with input as mock_input with data.repository as git_flow_repo
}

test_denies_non_actions_missing_target_in_git_flow if {
	mock_input := {"updates": [
		{"package-ecosystem": "npm", "groups": valid_groups},
		{"package-ecosystem": "pip", "groups": valid_groups},
	]}
	dependabot.deny == {
		"Dependabot update configuration for 'npm' is missing 'target-branch'",
		"Dependabot update configuration for 'pip' is missing 'target-branch'",
	} with input as mock_input with data.repository as git_flow_repo
}

test_allows_non_actions_targeting_develop_in_git_flow if {
	mock_input := {"updates": [{"package-ecosystem": "pip", "target-branch": "develop", "groups": valid_groups}]}
	no_violations with input as mock_input with data.repository as git_flow_repo
}

test_git_flow_mixed_updates if {
	mock_input := {"updates": [
		{"package-ecosystem": "github-actions", "groups": valid_groups},
		{"package-ecosystem": "npm", "target-branch": "develop", "groups": valid_groups},
		{"package-ecosystem": "pip", "target-branch": "main", "groups": valid_groups},
	]}
	dependabot.deny == {"Dependabot update configuration for 'pip' must target 'develop'"} with input as mock_input with data.repository as git_flow_repo
}

test_ignores_non_actions_branch_when_not_git_flow if {
	mock_input := {"updates": [{"package-ecosystem": "npm", "target-branch": "main", "groups": valid_groups}]}
	no_violations with input as mock_input with data.repository as {"defaultBranch": "main", "hasDevelopBranch": false}
	no_violations with input as mock_input with data.repository as {"defaultBranch": "process", "hasDevelopBranch": true}
}

test_actions_target_is_denied_in_git_flow if {
	mock_input := {"updates": [{"package-ecosystem": "github-actions", "target-branch": "main", "groups": valid_groups}]}
	dependabot.deny == {expected_message} with input as mock_input with data.repository as git_flow_repo
}

test_actions_empty_and_null_targets_are_denied_in_git_flow if {
	every target in ["", null] {
		mock_input := {"updates": [{"package-ecosystem": "github-actions", "target-branch": target, "groups": valid_groups}]}
		dependabot.deny == {expected_message} with input as mock_input with data.repository as git_flow_repo
	}
}

test_branch_and_group_violations_are_both_reported if {
	mock_input := {"updates": [{"package-ecosystem": "npm", "target-branch": "main"}]}
	dependabot.deny == {
		"Dependabot update configuration for 'npm' must target 'develop'",
		"Dependabot updates[0] must define a nonempty groups object with object definitions",
	} with input as mock_input with data.repository as git_flow_repo
}
