# Pass game, autohost lobby username and password as pillars

{% set maps = ['1944_Titan', '1944_Kiev_V4', '1944_Village_Crossing_v2', 'DeltaSiegeDry'] %}

User account for spads:
  user.present:
    - name: spads
    - shell: /bin/bash
    - home: /home/spads
    - password: password
    - groups:
      - sudo

Install required packages:
  pkg.installed:
    - pkgs:
      - swig
      - g++
      - perl
      - libcurl4-openssl-dev

Copy Spring to server:
  file.recurse:
    - name: /home/spads/spring
    - source: salt://files/spring
    - include_empty: True
    - user: spads
    - group: users
    - file_mode: keep

Copy SPADS to server:
  file.recurse:
    - name: /home/spads/spads
    - source: salt://files/spads
    - include_empty: True
    - user: spads
    - group: users
    - file_mode: keep

Install game:
  cmd.run:
    - name: "/home/spads/spring/bin/pr-downloader --download-game {{ pillar["game"] }}"
    - user: spads

{% for map in maps %}
/home/spads/spring/bin/pr-downloader --download-map {{ map }}:
  cmd.run:
    - user: spads
{% endfor %}

{% set config_files = ["hostingPresets.conf", "spads.conf", "users.conf", "S44Update.conf", "S44UpdateCmd.conf"] %}
{% set plugin_files = ["S44Update.pm", "S44UpdateHelp.dat"] %}

{% for config_file in config_files %}
/home/spads/spads/etc/{{config_file}}:
  file.managed:
    - source: salt://salt/spads/files/{{config_file}}
    - template: jinja
    - user: spads
    - group: users
    - file_mode: keep
    - makedirs: True
{% endfor %}

{% for plugin_file in plugin_files %}
/home/spads/spads/var/plugins/{{plugin_file}}:
  file.managed:
    - source: salt://salt/spads/files/{{plugin_file}}
    - template: jinja
    - user: spads
    - group: users
    - file_mode: keep
    - makedirs: True
{% endfor %}