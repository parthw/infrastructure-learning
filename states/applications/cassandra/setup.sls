

{% set cassandra_pillar = pillar.get('cassandra') %}
{% set fqdn = grains.get('fqdn') %}

# Setting up cassandra repo

setting_up_cassandra_repo:
  pkgrepo.managed:
    - name: cassandra
    - humanname: Apache Cassandra
    - baseurl: https://www.apache.org/dist/cassandra/redhat/{{ cassandra_pillar.get("repo_version") }}/
    - gpgcheck: 1
    - repo_gpgcheck: 1
    - gpgkey: https://www.apache.org/dist/cassandra/KEYS


# Required to lock cassandra package - (Not executed bootstrap?)

installing_yum_pkg_versionlock:
  pkg.installed:
    - name: yum-plugin-versionlock


# Installing cassandra

installing_cassandra_in_{{ fqdn }}:
  pkg.installed:
    - name: cassandra
    - version: {{ cassandra_pillar.get("cassandra_version") }}
    - hold: True
    - require:
      - setting_up_cassandra_repo
      - installing_yum_pkg_versionlock


# Deleting cassandra repo

deleting_cassandra_repo:
  pkgrepo.absent:
    - name: cassandra
    - require:
      - installing_cassandra_in_{{ fqdn }}


# Reloading systemd-daemon

reloading_systemd_daemon:
  cmd.run:
    - name: systemctl --system daemon-reload
    - require:
      - installing_cassandra_in_{{ fqdn }}


# Configuring cassandra

configuring_cassandra:
  file.recurse:
    - name: /etc/cassandra/default.conf
    - template: jinja
    - source: salt://applications/cassandra/conf


# Creating required directories

{% for dir in cassandra_pillar.get('directories').values() %}

creating_directory_{{ dir }}:
  file.directory:
    - name: {{ dir }}
    - user: cassandra
    - group: cassandra
    - mode: 755
    - makedirs: True
    - require:
      - configuring_cassandra

{% endfor %}


# Starting it at startup

enabling_auto_start_at_boot:
  cmd.run:
    - name: "systemctl enable cassandra"
    - require:
      - reloading_systemd_daemon

