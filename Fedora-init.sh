#!/usr/bin/env bash
#
# 2023-02-25  madd  init

dnf -y update
dnf -y install vim tmux wget atop htop etckeeper
etckeeper init
etckeeper commit init

cat >> /etc/vimrc <<EOF
set bg=dark
set expandtab ts=2 sw=2 ai
EOF

timedatectl set-timezone UTC

cat >> /etc/profile.d/sh.local <<EOF
export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'
export LC_COLLATE='C'
export LC_CTYPE='en_US.UTF-8'
export EDITOR='vim'
export HISTTIMEFORMAT="%F %T "
export HISTSIZE='10000'
export HISTCONTROL='ignorespace:erasedups'
export HISTIGNORE='ls:ps:history'
##

EOF

ssh-keygen -t ed25519 -P '' -f $HOME/.ssh/id_ed25519
cat >> $HOME/.ssh/authorized_keys <<KEY
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAxE0BavwCQhzfI31QUXwZWZFnVs/RiPSFoNY1C4LXy9lhPXMO2ZrIqCIeb7xX8wKQjQKTEdVUNIA+0/iRR484IkKZMvTk84oxQ+P+/BAlqZZFx9/oxyALXGcFB6w3JT5Utf9Gqgq10uiHwc/Nhcn1qHfpq24p131eeuebbSHexl7df5jBYYVNPBidc9g/wkQWx8AWMyxyVcidTQ0XzBvc3OjS/JWz2o24leMw3GRHI9x6HxBh1z2q3IgupkSxan9BcRlDLDj0zy5I6p1tDUDiYXiy9gZuMBXtBXWiC6eAw2KJQ89WP88JXbZ49jF+ej8PzLII+vtkLkvKicH7wGuuAIorIPNxzpVkTxpILxm/bND1EqfEEqej35yisE0kT0XF2BA5YQWm6E93g6sR+uy9uHvipkwj4TjDl9bLtIhr3T+GyrMdQiNWra3PE6WjoVsyFAJbN+s4UHby/nRxW6YujXu65Fn+iNphwWrULheAoL2XcxRKuBFtzZgO+Vf4ygwldLL+pXbGs+Vb6iHBKfTcUgbfYRH9bBHqb7QugaeWgP04qPCNimUo/+oEcujbCS5MnG5weDo1vGtkcBfGIqDJEpkty0jph/AXvBerRMNk08sw6TUPY2j0CKSxflId7OBak/eOixFZLY/G7IMyZFD3hhRO8bH+EVdPoQs99mgDZSc=
KEY
