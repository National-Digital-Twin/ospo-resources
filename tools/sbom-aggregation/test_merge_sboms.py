import sys
import json
import pytest
from unittest.mock import MagicMock, call
import merge_sboms

@pytest.fixture
def mock_sboms():
    """Provides mock SPDX documents for testing."""
    # Set up mock document for repo-one
    doc1 = MagicMock()
    pkg1 = MagicMock()
    pkg1.spdx_id = "SPDXRef-PackageA"
    
    rel1 = MagicMock()
    rel1.spdx_element_id = "SPDXRef-DOCUMENT"
    rel1.related_spdx_element_id = "SPDXRef-PackageA"
    
    doc1.packages = [pkg1]
    doc1.relationships = [rel1]

    # Set up mock document for repo-two
    doc2 = MagicMock()
    pkg2 = MagicMock()
    pkg2.spdx_id = "SPDXRef-PackageB"
    
    rel2 = MagicMock()
    rel2.spdx_element_id = "SPDXRef-DOCUMENT"
    rel2.related_spdx_element_id = "SPDXRef-PackageB"
    
    doc2.packages = [pkg2]
    doc2.relationships = [rel2]
    
    return [doc1, doc2]


def test_merge_sboms_updates_ids_and_writes_merged_document(mocker, mock_sboms):
    """
    Test that merge_sboms correctly parses multiple input files, prefixes 
    the SPDX package and relationship IDs with the origin file name to avoid
    collisions, and successfully writes the merged output document.
    """
    # Arrange
    output_file = "merged_output.spdx.json"
    input_files = ["repo-one.spdx.json", "repo-two.spdx.json"]

    mock_parse_file = mocker.patch("merge_sboms.parse_file")
    mock_write_file = mocker.patch("merge_sboms.write_file")
    
    # Configure parse_file to return our mock documents in order via the fixture
    mock_parse_file.side_effect = mock_sboms

    # Act
    merge_sboms.merge_sboms(output_file, input_files)

    # Assert
    # Check parse_file was called with the correct input files
    assert mock_parse_file.call_count == 2
    mock_parse_file.assert_has_calls([call("repo-one.spdx.json"), call("repo-two.spdx.json")])

    # Check write_file was called exactly once
    mock_write_file.assert_called_once()
    
    # Verify the merged document structure and output file passed to write_file
    merged_doc = mock_write_file.call_args[0][0]
    called_output_file = mock_write_file.call_args[0][1]
    
    assert called_output_file == output_file
    
    # Verify the package IDs were updated with the correct prefix mapping
    assert len(merged_doc.packages) == 2
    assert merged_doc.packages[0].spdx_id == "SPDXRef-repo-one-PackageA"
    assert merged_doc.packages[1].spdx_id == "SPDXRef-repo-two-PackageB"

    # Verify the relationships were updated to point to the renamed IDs
    assert len(merged_doc.relationships) == 2
    assert merged_doc.relationships[0].related_spdx_element_id == "SPDXRef-repo-one-PackageA"
    assert merged_doc.relationships[1].related_spdx_element_id == "SPDXRef-repo-two-PackageB"


def test_main_prints_usage_and_exits_when_insufficient_args(mocker):
    """
    Test that the main function validates terminal arguments. It should print 
    the proper script usage and gracefully exit the program with code 1 if the
    user fails to provide at least an output file and one input file.
    """
    # Arrange
    test_args = ["merge_sboms.py", "output.json"]  # Missing input files
    mocker.patch.object(sys, "argv", test_args)
    
    mock_print = mocker.patch("builtins.print")
    
    # Mock sys.exit to prevent the actual ValueError from executing or the test runner crashing
    mock_exit = mocker.patch("sys.exit")
    mock_exit.side_effect = SystemExit(1) # simulate exactly what it does so it stops execution inline

    # Act
    with pytest.raises(SystemExit) as exc_info:
        merge_sboms.main()

    # Assert
    assert exc_info.value.code == 1
    mock_print.assert_called_once_with("Usage: merge_sboms.py <output_file> <input1> <input2> ...")
    mock_exit.assert_called_once_with(1)


def test_main_calls_merge_sboms_with_parsed_arguments(mocker):
    """
    Test that the main function correctly parses the terminal execution arguments,
    separating the target output file from the list of input files, before passing
    them sequentially to the core merge_sboms function.
    """
    # Arrange
    test_args = ["merge_sboms.py", "final.json", "in1.json", "in2.json"]
    mocker.patch.object(sys, "argv", test_args)
    
    mock_merge_sboms = mocker.patch("merge_sboms.merge_sboms")

    # Act
    merge_sboms.main()

    # Assert
    mock_merge_sboms.assert_called_once_with("final.json", ["in1.json", "in2.json"])


def test_merge_sboms_integration_creates_valid_file(tmp_path):
    """
    Integration test asserting that when actual valid SPDX JSON structures are 
    provided on disk, the script fully successfully reads them, parses them through
    spdx_tools, avoids schema validation failures, and produces a real merged JSON file.
    """
    # Arrange
    # Create two minimal but valid SPDX JSON strings
    spdx_doc1 = {
        "spdxVersion": "SPDX-2.3",
        "dataLicense": "CC0-1.0",
        "SPDXID": "SPDXRef-DOCUMENT",
        "name": "Repo1-SBOM",
        "documentNamespace": "http://spdx.org/spdxdocs/repo1",
        "creationInfo": {
            "creators": ["Tool: DummyTool"],
            "created": "2026-03-17T00:00:00Z"
        },
        "packages": [
            {
                "name": "package-a",
                "SPDXID": "SPDXRef-PackageA",
                "downloadLocation": "NOASSERTION",
                "filesAnalyzed": False
            }
        ],
        "relationships": [
            {
                "spdxElementId": "SPDXRef-DOCUMENT",
                "relatedSpdxElement": "SPDXRef-PackageA",
                "relationshipType": "DESCRIBES"
            }
        ]
    }

    spdx_doc2 = {
        "spdxVersion": "SPDX-2.3",
        "dataLicense": "CC0-1.0",
        "SPDXID": "SPDXRef-DOCUMENT",
        "name": "Repo2-SBOM",
        "documentNamespace": "http://spdx.org/spdxdocs/repo2",
        "creationInfo": {
            "creators": ["Tool: DummyTool"],
            "created": "2026-03-17T00:00:00Z"
        },
        "packages": [
            {
                "name": "package-b",
                "SPDXID": "SPDXRef-PackageB",
                "downloadLocation": "NOASSERTION",
                "filesAnalyzed": False
            }
        ],
        "relationships": [
            {
                "spdxElementId": "SPDXRef-DOCUMENT",
                "relatedSpdxElement": "SPDXRef-PackageB",
                "relationshipType": "DESCRIBES"
            }
        ]
    }

    # Write source files to pytest temporary directory
    file1 = tmp_path / "repo-one.json"
    file2 = tmp_path / "repo-two.json"
    output_file = tmp_path / "merged.json"
    
    file1.write_text(json.dumps(spdx_doc1))
    file2.write_text(json.dumps(spdx_doc2))

    # Act
    # Execute the actual integration logic against physical mock files
    merge_sboms.merge_sboms(str(output_file), [str(file1), str(file2)])

    # Assert
    assert output_file.exists()
    
    # Read the data back entirely from disk to ensure schema generation succeeded
    merged_data = json.loads(output_file.read_text())
    
    assert merged_data["spdxVersion"] == "SPDX-2.3"
    assert merged_data["name"] == "Merged SBOM"
    assert len(merged_data["packages"]) == 2
    
    merged_package_ids = [p["SPDXID"] for p in merged_data["packages"]]
    assert "SPDXRef-repo-one-PackageA" in merged_package_ids
    assert "SPDXRef-repo-two-PackageB" in merged_package_ids
    
    # Validate relationships were prefixed safely 
    # and map appropriately inside output file relationships array
    merged_relationship_refs = [r["relatedSpdxElement"] for r in merged_data["relationships"]]
    assert "SPDXRef-repo-one-PackageA" in merged_relationship_refs
    assert "SPDXRef-repo-two-PackageB" in merged_relationship_refs
