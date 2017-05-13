user account for vnc:
  user.present:
    - name: vnc
    - shell: /bin/bash
    - home: /home/vnc
    - password: 12345
    - groups:
      - sudo

install_network_packages:
  pkg.installed:
    - pkgs:
      - rsync
      - lftp
      - curl

