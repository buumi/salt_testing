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
    - dir_mode: keep

Copy SPADS to server:
  file.recurse:
    - name: /home/spads/spads
    - source: salt://files/spads
    - include_empty: True
    - user: spads
    - group: users
    - file_mode: keep
    - dir_mode: keep

Install game:
  cmd.run:
    - name: /home/spads/spring/bin/pr-downloader --download-game {{ pillar["game"] }}
    - user: spads

{% for map in maps %}
/home/spads/spring/bin/pr-downloader --download-map {{ map }}:
  cmd.run:
    - user: spads
{% endfor %}

Update hostingPresets.conf:
  file.managed:
    - name: /home/spads/spads/etc/hostingPresets.conf
    - source: salt://salt/spads/files/hostingPresets.conf
    - template: jinja
    - user: spads
    - group: users
    - file_mode: keep

Update spads.conf:
  file.managed:
    - name: /home/spads/spads/etc/spads.conf
    - source: salt://salt/spads/files/spads.conf
    - template: jinja
    - user: spads
    - group: users
    - file_mode: keep

Update users.conf:
  file.managed:
    - name: /home/spads/spads/etc/users.conf
    - source: salt://salt/spads/files/users.conf
    - user: spads
    - group: users
    - file_mode: keep