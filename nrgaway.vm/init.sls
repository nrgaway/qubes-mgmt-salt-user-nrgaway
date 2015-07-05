# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# nrgaway
# =======
#
#  For root and user:
#    - Installs enhanced .bash* configuration files.
#      - The .bash* files also prevent .bash_history from being written
#    - Installs .vimrc
#      - Prevents vim history from being written
#
# Execute:
#   qubesctl state.sls nrgaway user
##

nrgaway-root:
  file:
    - name: /root
    - recurse
    - source: salt://privacy/files/root
    - user: root
    - group: root
    - clean: False  # Do not delete all files in target first
    - replace: True  # Replace existing files (n/a in recurse?)
    - dir_mode: 750
    - file_mode: 640
    - makedirs: True

nrgaway-user:
  file:
    - name: /home/user
    - recurse
    - source: salt://privacy/files/user
    - user: user
    - group: user
    - clean: False  # Do not delete all files in target first
    - replace: True  # Replace existing files (n/a in recurse?)
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
