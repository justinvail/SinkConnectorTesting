#!/bin/sh

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo '----------------------------------------------------------------------------------------------------------------';
echo 'Stopping and removing all docker containers and networks';
echo '----------------------------------------------------------------------------------------------------------------';
"${SCRIPT_DIR}"/./stopAll.sh
echo
echo
echo

echo '----------------------------------------------------------------------------------------------------------------';
echo 'Creating and starting all docker containers and networks';
echo '----------------------------------------------------------------------------------------------------------------';
docker-compose -f "${SCRIPT_DIR}"/../docker-compose.yml up -d;
echo
echo
echo

echo '----------------------------------------------------------------------------------------------------------------';
echo 'Waiting for Kafka to be ready for connector config and messages (Polling c3 url: localhost:9021)';
echo '----------------------------------------------------------------------------------------------------------------';
until curl --output /dev/null --silent --head --fail http://localhost:9021; do
    printf '.'
    sleep 3
done
printf "\n"
echo
echo
echo

echo '----------------------------------------------------------------------------------------------------------------';
echo 'Creating sink connector';
echo '----------------------------------------------------------------------------------------------------------------';
"${SCRIPT_DIR}"/./createSinkConnector.sh
printf "\n"
echo
echo
echo

echo '----------------------------------------------------------------------------------------------------------------';
echo 'Creating Avro messages and pushing to topic';
echo '----------------------------------------------------------------------------------------------------------------';
"${SCRIPT_DIR}"/./produceAvroMessages.sh
echo
echo
echo
