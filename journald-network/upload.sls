# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "journald-network/map.jinja" import journald_upload with context %}

{% if grains['os'] == 'Debian'%}
journald_remote_pkg:
  pkg.installed:
    - pkgs:
      - systemd-journal-remote
    - require_in:
      - service: journald_upload
{% endif %}

journald_upload:
  file.managed:
    - name: /etc/systemd/journal-upload.conf
    - source: salt://journald-network/files/journal-upload.conf.tmpl
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        url: {{ journald_upload.url }}
        key: {{ journald_upload.key }}
        cert: {{ journald_upload.cert }}
        ca: {{ journald_upload.ca }}
  service.running:
    - name: systemd-journal-upload.service
    - enable: true
    - onchanges:
      - file: journald_upload
    - require:
      - file: journald_upload
