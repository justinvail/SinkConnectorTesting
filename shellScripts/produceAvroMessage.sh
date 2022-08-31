#!/bin/sh

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "${SCRIPT_DIR}" || exit;
cd ../contentionBaseMessages || exit;
TOPIC=local-contention-event-base
AVRO_SCHEMA_FILE=../schemas/ContentionEventBase.avsc
PAYLOAD=$1
echo "Processing file: ${PAYLOAD}"
#
# Take the Avro Schema and convert it into the format that Schema Registry accepts
#
# shellcheck disable=SC2002
SCHEMA=$(cat ${AVRO_SCHEMA_FILE} | sed 's/"/\\\"/g' | tr -d '\n')

SR=$( cat <<EOF
{
  "schema": "${SCHEMA}"
}
EOF
)

#
# Publish Schema with Schema Registry
#
ID=$(curl -s -X POST -H "Content-Type: application/json" --data "$SR" http://localhost:8081/subjects/${TOPIC}-value/versions | jq .id)

# Magic Byte 0x00
printf '\x00' > temp/data_file

# Schema Registry ID as 32bit WORD
printf "0: %.8x" "$ID" | xxd -r -g0 >> temp/data_file

# Convert JSON payload into Avro using avro-tools, write the binary data to the file
avro-tools jsontofrag --schema-file ${AVRO_SCHEMA_FILE} ${PAYLOAD} >> temp/data_file

# Publish the file using kcat add /dev/null to ensure file is treated as a single message
kcat -P -e -b localhost:9092 -t ${TOPIC} temp/data_file /dev/null
