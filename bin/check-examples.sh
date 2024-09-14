#! /bin/bash
#
# Validates SPDX example, both in separate files and inline in the
# documentation
#
# SPDX-License-Identifier: MIT

set -e

THIS_DIR="$(dirname "$0")"
SPDX_VERSION="3.0.1"
SCHEMA_URL="https://spdx.org/schema/${SPDX_VERSION}/spdx-json-schema.json"
RDF_URL="https://spdx.org/rdf/${SPDX_VERSION}/spdx-model.ttl"
CONTEXT_URL="https://spdx.org/rdf/${SPDX_VERSION}/spdx-context.jsonld"

# print validation setup
echo "Checking examples"
echo "SPDX version     : $SPDX_VERSION"
echo "Schema           : $SCHEMA_URL"
echo "Schema resolved  : $(curl -I "$SCHEMA_URL" 2>/dev/null | grep -i "location:" | awk '{print $2}')"
echo "RDF              : $RDF_URL"
echo "RDF resolved     : $(curl -I "$RDF_URL" 2>/dev/null | grep -i "location:" | awk '{print $2}')"
echo "Context          : $CONTEXT_URL"
echo "Context resolved : $(curl -I "$CONTEXT_URL" 2>/dev/null | grep -i "location:" | awk '{print $2}')"
echo "$(check-jsonschema --version)"
echo -n "$(pyshacl --version)"
echo "spdx3-validate version: $(spdx3-validate --version)"
echo ""

check_schema() {
    echo "Checking schema (check-jsonschema): $1"
    check-jsonschema \
        --verbose \
        --schemafile $SCHEMA_URL \
        "$1"
}

check_model() {
    echo "Checking model (pyschacl): $1"
    pyshacl \
        --shacl $RDF_URL \
        --ont-graph $RDF_URL \
        "$1"
}

validate() {
    echo "Validating (spdx3-validate): $1"
    spdx3-validate --json $1
}

# Check examples in JSON files in examples/jsonld/
if [ "$(ls $THIS_DIR/../examples/jsonld/*.json 2>/dev/null)" ]; then
    for f in $THIS_DIR/../examples/jsonld/*.json; do
        check_schema $f
        echo ""
        check_model $f
        echo ""
        validate $f
        echo ""
    done
fi

TEMP=$(mktemp -d)

# Check examples in inline code snippets in Markdown files in docs/annexes/
for f in $THIS_DIR/../docs/annexes/*.md; do
    if ! grep -q '^```json' $f; then
        continue
    fi
    echo "Extract snippets from $f"
    DEST=$TEMP/$(basename $f)
    mkdir -p $DEST

    # Read inline code snippets and save them in separate, numbered files.
    cat $f | awk -v DEST="$DEST" 'BEGIN{flag=0} /^```json/, $0=="```" { if (/^---$/){flag++} else if ($0 !~ /^```.*/ ) print $0 > DEST "/doc-" flag ".spdx.json"}'

    # Combine all JSON code snippets into a single file, with SPDX context and creation info.
    echo "[" > $DEST/combined.json

    for doc in $DEST/*.spdx.json; do
        if ! grep -q '@context' $doc; then
            mv $doc $doc.fragment
            cat >> $doc <<HEREDOC
{
    "@context": "$CONTEXT_URL",
    "@graph": [
HEREDOC
            cat $doc.fragment >> $doc
            cat >> $doc <<HEREDOC
        {
            "type": "CreationInfo",
            "@id": "_:creationInfo",
            "specVersion": "$SPDX_VERSION",
            "created": "2024-04-23T00:00:00Z",
            "createdBy": [
                {
                    "type": "Agent",
                    "spdxId": "http://spdx.dev/dummy-agent",
                    "creationInfo": "_:creationInfo"
                }
            ]
        }
    ]
}
HEREDOC
        fi
        check_schema $doc
        echo ""
        cat $doc >> $DEST/combined.json
        echo "," >> $DEST/combined.json
    done

    echo "{}]" >> $DEST/combined.json

    check_model $DEST/combined.json
    echo ""
    validate $DEST/combined.json
    echo ""
done
