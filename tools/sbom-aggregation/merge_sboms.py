# SPDX-License-Identifier: Apache-2.0
# © Crown Copyright 2025. This work has been developed by the National Digital Twin Programme and is legally attributed to the Department for Business and Trade (UK) as the governing entity.

import os
import sys
from datetime import datetime, timezone
from spdx_tools.spdx.model import Document, CreationInfo, Actor, ActorType
from spdx_tools.spdx.parser.parse_anything import parse_file
from spdx_tools.spdx.writer.write_anything import write_file

if len(sys.argv) < 3:
    print("Usage: merge_sboms.py <output_file> <input1> <input2> ...")
    sys.exit(1)

output_file = sys.argv[1]
input_files = sys.argv[2:]

# Create minimal creation info required by SPDX specification
creation_info = CreationInfo(
    spdx_version="SPDX-2.3",
    created=datetime.now(timezone.utc),
    name="Merged SBOM",
    document_namespace="https://replace-with-your-preferred-organisation-namespace/spdx/",
    creators=[Actor(ActorType.TOOL, "sbom-aggregator/1.0")],
    spdx_id="SPDXRef-DOCUMENT",
)

# Create the document with basic metadata
merged = Document(creation_info=creation_info)

id_mapping = {}

for file_path in input_files:
    repo_name = os.path.basename(file_path).split(".")[0]  # Use file name as repo name
    doc = parse_file(file_path)

    # Update package IDs
    for pkg in doc.packages:
        old_id = pkg.spdx_id
        new_id = f"SPDXRef-{repo_name}-{old_id.split('SPDXRef-')[-1]}"
        id_mapping[old_id] = new_id
        pkg.spdx_id = new_id
        merged.packages.append(pkg)

    # Update relationships
    for rel in doc.relationships:
        # Patch related SPDX IDs
        related_id = rel.related_spdx_element_id
        source_id = rel.spdx_element_id

        rel.related_spdx_element_id = id_mapping.get(related_id, related_id)
        rel.spdx_element_id = id_mapping.get(source_id, source_id)

        merged.relationships.append(rel)

write_file(merged, output_file)

