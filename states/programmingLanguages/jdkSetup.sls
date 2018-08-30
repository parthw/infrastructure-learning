
# Bootstrap state must be executed first

{% set jdk_pillar = pillar.get('jdk') %}
{% set fqdn = grains.get('fqdn') %}


# Download the tar.gz file

download_java_source_at_{{ fqdn }}:
  cmd.run:
    - name: "wget --no-cookies --no-check-certificate --header 'Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie' {{ jdk_pillar['jdk_URL'] }}"
    - cwd: /opt/src
    - unless: test -e {{ jdk_pillar['jdk_filename'] }}


# Download the security jars

download_jce_policy_at_{{ fqdn }}:
  cmd.run:
    - name: "wget --no-cookies --no-check-certificate --header 'Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie'  {{ jdk_pillar['jce_URL'] }}"
    - cwd: /opt/src
    - unless: test -e {{ jdk_pillar['jce_filename'] }}


# Extracting packages

extract_java_source_at_{{ fqdn }}:
  archive.extracted:
    - name: "/opt/pkgs/"
    - source: /opt/src/{{ jdk_pillar['jdk_filename'] }}
    - user: root
    - group: root
    - require:
      - download_java_source_at_{{ fqdn }}

extract_jce_policy_at_{{ fqdn }}:
  archive.extracted:
    - name: "/opt/pkgs/"
    - source: /opt/src/{{ jdk_pillar['jce_filename'] }}
    - require:
      - download_jce_policy_at_{{ fqdn }}


# Copying security jars

copying_local_policy_to_jdk_at_{{ fqdn }}:
  file.copy:
    - source: "/opt/pkgs/{{ jdk_pillar['jce_extracted_dir'] }}/local_policy.jar" 
    - name: "/opt/pkgs/{{ jdk_pillar['jdk_extracted_dir'] }}/jre/lib/security/local_policy.jar"
    - user: root
    - group: root
    - mode: 755
    - require:
      - extract_jce_policy_at_{{ fqdn }}
      - extract_java_source_at_{{ fqdn }}

copying_US_export_policy_to_jdk_at_{{ fqdn }}:
  file.copy:
    - source: "/opt/pkgs/{{ jdk_pillar['jce_extracted_dir'] }}/US_export_policy.jar" 
    - name: "/opt/pkgs/{{ jdk_pillar['jdk_extracted_dir'] }}/jre/lib/security/US_export_policy.jar"
    - user: root
    - group: root
    - mode: 755
    - require:
      - extract_jce_policy_at_{{ fqdn }}
      - extract_java_source_at_{{ fqdn }}


# Setting up Java

alternatives_{{ jdk_pillar['jdk_extracted_dir'] }}_install_at_{{ fqdn }}:
  alternatives.install:
    - name: java
    - link: /usr/bin/java
    - path: /opt/pkgs/{{ jdk_pillar['jdk_extracted_dir'] }}/bin/java
    - priority: 30
    - require:
      - copying_US_export_policy_to_jdk_at_{{ fqdn }}
      - copying_local_policy_to_jdk_at_{{ fqdn }}


# Adding JAVA_HOME

appending_etc_environment_at_{{ fqdn }}:
  file.append:
    - name: /etc/environment
    - text:
      - export JAVA_HOME=/opt/pkgs/{{ jdk_pillar['jdk_extracted_dir'] }}/bin
