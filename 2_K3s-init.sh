#!/usr/bin/env bash
#
# 2023-02-26  madd  init

# node 1
curl -sfL https://get.k3s.io | sh -s - server --cluster-init

# node 2 + 3
curl -sfL https://get.k3s.io | K3S_URL=https://swfs-01:6443 K3S_TOKEN=SECRET sh -s - server --server https://swfs-01:6443

# all nodes
setfacl -m u:fedora:rw /etc/rancher/k3s/k3s.yaml

# README 
# => https://docs.k3s.io/cluster-access
# => https://docs.k3s.io/upgrades/automated
# => https://docs.k3s.io/storage (nice to know, but i think we dont need / use it.
#
