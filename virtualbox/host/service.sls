{%- from "virtualbox/map.jinja" import host with context %}
{%- if host.enabled %}

{%- if grains.os_family == 'Debian' %}

virtualbox_repo:
  pkgrepo.managed:
  - human_name: virtualbox
  - name: deb http://download.virtualbox.org/virtualbox/debian {{ grains.oscodename }} contrib
  - file: /etc/apt/sources.list.d/virtualbox.list
  - key_url: salt://virtualbox/files/virtualbox-apt.gpg

virtualbox_packages:
  pkg.installed:
  - names:
    - build-essential
    - dkms
    - linux-headers-{{ grains.kernelrelease }}
  - require:
    - pkgrepo: virtualbox_repo

virtualbox_package:
  pkg.installed:
    - version: {{ host.version }}
    - names:
      - virtualbox
    - require:
      - pkgrepo: virtualbox_repo

virtualbox_setup_kernel_drivers:
  cmd.wait:
  - name: /etc/init.d/vboxdrv setup
  - cwd: /root
  - watch:
    - pkg: virtualbox_packages
    - pkg: virtualbox_package

{%- elif grains.os_family == "RedHat" %}

{# TODO #}

{%- elif grains.os_family == "Windows" %}

virtualbox_install_package:
  pkg.installed:
  - name: virtualbox_x64_en

{%- endif %}
{%- endif %}