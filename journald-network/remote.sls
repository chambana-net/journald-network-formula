# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "journald-network/map.jinja" import journald_remote with context %}

journald_remote:
  file.managed:
    - name: /etc/systemd/journal-remote.conf
    - source: salt://journald_remote/files/journal-remote.conf.tmpl
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        seal: {{ journald_remote.seal }}
        split_mode: {{ journald_remote.split_mode }}
        key: {{ journald_remote.key }}
        cert: {{ journald_remote.cert }}
        ca: {{ journald_remote.ca }}
  service.running:
    - name: systemd-journald-remote.service
    - enable: true
    - onchanges:
      - file: journald_remote
    - require:
      - file: journald_remote

journald_remote_socket:
  service.running:
    - name: systemd-journald-remote.socket
    - enable: true
    - require:
      - file: journald_remote
