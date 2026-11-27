# SPDX-License-Identifier: Apache-2.0
# © Crown Copyright 2026. This work has been developed by the National Digital Twin Programme and is legally
# attributed to the UK's Department for Business, Innovation, Science and Trade (BIST) as the governing entity.
package github.dependabot

# METADATA
# description: Require a nonempty groups object with object definitions for each applicable Dependabot update entry
deny contains msg if {
	some index, update in input.updates
	is_object(update)
	grouping_applies(update)
	not valid_groups(update)
	msg := $"Dependabot updates[{index}] must define a nonempty groups object with object definitions"
}

# METADATA
# description: Require at least one version-update group unless version updates are disabled
deny contains msg if {
	some index, update in input.updates
	is_object(update)
	not version_updates_disabled(update)
	valid_groups(update)
	not has_version_group(update.groups)
	msg := $"Dependabot updates[{index}] must include a version-update group"
}

grouping_applies(update) if {
	not version_updates_disabled(update)
}

grouping_applies(update) if {
	"groups" in object.keys(update)
}

valid_groups(update) if {
	is_object(update.groups)
	count(update.groups) > 0
	every _, group in update.groups {
		is_object(group)
	}
}

version_updates_disabled(update) if {
	update["open-pull-requests-limit"] == 0
}

has_version_group(groups) if {
	some name in object.keys(groups)
	group := groups[name]
	object.get(group, "applies-to", "version-updates") == "version-updates"
}
