SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" --data "@${SCRIPT_DIR}/../connectConfigs/sinkConnector.json"