
cassandra:
  repo_version: 30x
  cassandra_version: 3.0.13
  ssl_storage_port: 7003
  storage_port: 7002
  native_transport_port: 9044
  rpc_port: 9162
  directories:
    hints_dir: /data/cassandra/hints
    data_dir: /data/cassandra/data
    commitlog_dir: /opt/cassandra_commitlog
    saved_caches_dir: /data/cassandra/saved_caches
    jvm_tmp_dir: /var/lib/cassandra/tmp
  
  cluster_topology:
    centos:
      datacenter: D1
      rack: Rack1
      seedNode: True
    minion:
      datacenter: D2
      rack: Rack2
      seedNode: True
