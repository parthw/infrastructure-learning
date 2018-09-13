
# Written on 12 Sept. 2018

# Steps to setup cassandra cluster (Assuming you already executed bootstrap)
# 1. Edit cassandra.yaml present in applications/cassandra/conf
#    - change concurrent reads
#    - change concurrent writes
#    - change counter writes
#    - change concurrent_materialized_view_writes
# 2. Verify JDK and JCE URL in pillar/programmingLanguages/jdkSetup.sls
# 3. Execute this orchestration state
# 4. Enable encryption
# 5. Start the seed node first
# 6. If more nodes are need to be added; increase the replication factor of system_auth and change the replication strategy.
# 7. Start non-seed nodes.


# Installing JDK

install_java:
  salt.state:
    - tgt: 'custom_grains:cassandra:True'
    - tgt_type: grain
    - sls:
      - programmingLanguages.jdkSetup


# Installing Cassandra

install_cassandra:
  salt.state:
    - tgt: 'custom_grains:cassandra:True'
    - tgt_type: grain
    - sls:
      - applications.cassandra
