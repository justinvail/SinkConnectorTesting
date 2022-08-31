#!/bin/sh

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd "${SCRIPT_DIR}" || exit;

cd ../contentionBaseMessages || exit;

#for FILE in *; do echo "$FILE"; done

rm temp/data_file

for FILE in *.json; do "${SCRIPT_DIR}"/produceAvroMessage.sh "$FILE"; done