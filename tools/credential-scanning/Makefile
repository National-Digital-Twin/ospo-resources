# SPDX-License-Identifier: Apache-2.0
# © Crown Copyright 2025. This work has been developed by the National Digital Twin Programme and is legally attributed to the Department for Business and Trade (UK) as the governing entity.

git-credential-config: create-credential-exclusions-file-if-not-exists bind-pre-commit

bind-pre-commit:
	chmod -R +x .githooks
	git config --global core.hooksPath .githooks/

bind-pre-local-only:
	chmod -R +x .githooks
	git config --global core.hooksPath .githooks/

create-credential-exclusions-file-if-not-exists:
ifeq (,$(wildcard credential-scan-exclusions.txt))
	echo "# File contents should include line separated regex filepaths (analagous to a gitignore file)" > credential-scan-exclusions.txt
endif

credential-scan-verified:
	docker run --rm -it -v $(PWD):/opt trufflesecurity/trufflehog:latest git file:///opt --only-verified --fail

credential-scan-unverified:
	docker run --rm -it -v $(PWD):/opt trufflesecurity/trufflehog:latest filesystem /opt --fail --exclude-paths /opt/credential-scan-exclusions.txt

credential-scan-verified-no-update-no-log:
	docker run --rm -it -v $(PWD):/opt trufflesecurity/trufflehog:latest git file:///opt --only-verified --no-update --fail > /dev/null

credential-scan-unverified-no-update-no-log:
	docker run --rm -it -v $(PWD):/opt trufflesecurity/trufflehog:latest git file:///opt --no-update --fail > /dev/null