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

Copy Spring to server:
  /home/spads/spring:
    file.recurse:
      - source: salt://files/spring
      - include_empty: True
      - user: spads
      - group: users

Copy SPADS to server:
  /home/spads/spads:
    file.recurse:
      - source: salt://files/spads
      - include_empty: True
      - user: spads
      - group: users