# SPDX-License-Identifier: Apache-2.0
# Crown Copyright 2026. This work has been developed by the National Digital Twin Programme and is legally
# attributed to the UK's Department for Business, Innovation, Science and Trade (BIST) as the governing entity.
package github.dependabot_test

import data.github.dependabot

test_every_update_entry_needs_a_group if {
	input_config := {"updates": [
		{"package-ecosystem": "npm", "groups": {"routine": {}}},
		{"package-ecosystem": "npm", "directory": "/api"},
	]}
	count(dependabot.deny) > 0 with input as input_config
}

test_groups_must_be_nonempty_objects if {
	input_config := {"updates": [{"package-ecosystem": "npm", "groups": {"routine": null}}]}
	count(dependabot.deny) > 0 with input as input_config
}

test_empty_groups_are_rejected if {
	input_config := {"updates": [{"package-ecosystem": "npm", "groups": {}}]}
	count(dependabot.deny) > 0 with input as input_config
}

test_omitted_applies_to_defaults_to_version_updates if {
	input_config := {"updates": [{"package-ecosystem": "npm", "groups": {"routine": {"patterns": ["@types/*"]}}}]}
	count(dependabot.deny) == 0 with input as input_config
}

test_security_only_group_does_not_satisfy_version_updates if {
	input_config := {"updates": [{"package-ecosystem": "npm", "groups": {"security": {"applies-to": "security-updates"}}}]}
	count(dependabot.deny) > 0 with input as input_config
}

test_separate_security_and_version_groups_are_allowed if {
	input_config := {"updates": [{"package-ecosystem": "npm", "groups": {
		"routine": {"update-types": ["minor", "patch"]},
		"security": {"applies-to": "security-updates"},
	}}]}
	count(dependabot.deny) == 0 with input as input_config
}

test_numeric_zero_disables_version_group_requirement if {
	input_config := {"updates": [{"package-ecosystem": "npm", "open-pull-requests-limit": 0}]}
	count(dependabot.deny) == 0 with input as input_config
}

test_disabled_entry_still_rejects_malformed_groups if {
	input_config := {"updates": [{"package-ecosystem": "npm", "open-pull-requests-limit": 0, "groups": null}]}
	count(dependabot.deny) > 0 with input as input_config
}

test_string_zero_does_not_disable_version_group_requirement if {
	input_config := {"updates": [{"package-ecosystem": "npm", "open-pull-requests-limit": "0"}]}
	count(dependabot.deny) > 0 with input as input_config
}

test_zero_does_not_bypass_existing_branch_checks if {
	input_config := {"updates": [{
		"package-ecosystem": "npm",
		"open-pull-requests-limit": 0,
		"target-branch": "main",
	}]}
	result := dependabot.deny with input as input_config with data.repository as {"defaultBranch": "main", "hasDevelopBranch": true}
	result == {"Dependabot update configuration for 'npm' must target 'develop'"}
}
