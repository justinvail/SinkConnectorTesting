# SinkConnectorTesting

This repository was created to aid in the testing of Kafka sink connector configurations.  The current implementation is based around 
a jdbc oracle sink connector for ContentionEventBase.avsc messages.  The schema can be found [here]( 
https://github.com/department-of-veterans-affairs/bip-bie-claim-contention-sp/blob/master/sp-app/src/main/resources/avro/helpers/ContentionEventBase.avsc)
as well as an internal copy [here](./schemas/ContentionEventBase.avsc).

Testing Kafka connector configurations is a heavy lift.  We will need an entire local kafka environment, a topic, a 
schema loaded in schema registry, and avro messages being produced to the topic.  All this needs to take place just to 
test less than 30 lines of [configuration](./connectConfigs/sinkConnector.json).  So, hopefully this will be useful to 
others that find themselves in a holding pattern waiting for topics to materialize.  This allows us to use the avro 
schema as a contract and work out the entire database portion (sink connector configuration and database structure). 
This will allow any work relying on the database data/structure to continue without impediment. 

This repository does the following:
- Sets up a local kafka environment in docker.  This includes:
  - ZooKeeper
  - Kafka
  - Confluent Command Center
  - Schema Registry
  - Kafka Connect
  - and a temp container to set up the single topic we are testing
- It also has shell scripts that:
  - read json files representing data for messages (not yet in avro format)
  - convert them to binary avro
  - register the schema in Schema Registry
  - produce avro messages to topic
  - set up a sink connector
  - and convenience scripts to start and stop everything at once 

There are some PreRequisites for running these scripts.  If you are using a Mac and using Brew, you can run the 
[installMacPrereqs](./shellScripts/installMacPrereqs.sh) to install all of them.  They are: 
- avro-tools
- jq
- kcat
