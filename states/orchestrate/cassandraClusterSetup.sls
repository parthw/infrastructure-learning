
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
