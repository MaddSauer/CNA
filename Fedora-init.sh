#!/usr/bin/env bash
#
# 2023-02-25  madd  init

dnf -y update
dnf -y install vim tmux wget atop htop etckeeper
etckeeper init
etckeeper init commit

cat >> /etc/vimrc <<EOF
set bg=dark
set expandtab ts=2 sw=2 ai
EOF

