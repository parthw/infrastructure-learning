
{% set bootstrap_pillar = pillar.get('bootstrap') %}

{% for dir in bootstrap_pillar.get('directories') %}

creating_directory_{{ dir }}:
  file.directory:
    - name: {{ dir }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

{% endfor %}
