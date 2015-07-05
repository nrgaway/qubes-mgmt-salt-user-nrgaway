##
# privacy
#
#   For root and user:
#     - Installs enhanced .bash* configuration files.
#       - The .bash* files also prevent .bash_history from being written
#     - Installs .vimrc
#       - Prevents vim history from being written
#
#  TODO:
#    - block locate database from indexing user directories
##

/root:
  file:
    - recurse
    - source: salt://privacy/files/root
    - user: root
    - group: root
    - clean: False  # Do not delete all files in target first
    - replace: True  # Replace existing files (n/a in recurse?)
    - dir_mode: 750
    - file_mode: 640
    - makedirs: True

/home/user:
  file:
    - recurse
    - source: salt://privacy/files/user
    - user: user
    - group: user
    - clean: False  # Do not delete all files in target first
    - replace: True  # Replace existing files (n/a in recurse?)
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
