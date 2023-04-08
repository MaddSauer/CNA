#!/usr/bin/env bash
#
# 2023-02-26  madd  init
# 2023-04-08  madd  changed a should be state - not tested
#

# server node 1
curl -sfL https://get.k3s.io | sh -s - server --cluster-init --disable traefik --write-kubeconfig-mode 644

# server node 1 (cilium)
curl -sfL https://get.k3s.io | sh -s - server --cluster-init --disable traefik --write-kubeconfig-mode 644 --flannel-backend=none --no-flannel
kubectl create -f https://raw.githubusercontent.com/cilium/cilium/v1.8/install/kubernetes/quick-install.yaml
cat <<EOF | sudo tee /etc/systemd/system/sys-fs-bpf.mount
[Unit]
Description=Cilium BPF mounts
Documentation=https://docs.cilium.io/
DefaultDependencies=no
Before=local-fs.target umount.target
After=swap.target

[Mount]
What=bpffs
Where=/sys/fs/bpf
Type=bpf
Options=rw,nosuid,nodev,noexec,relatime,mode=700

[Install]
WantedBy=multi-user.target
EOF
# TODO create daemonset to deploy on every node.

# cilium on CRIO systems
helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --version 1.8.13 \
  --namespace kube-system \
  --set global.containerRuntime.integration=crio



# server node 2 + 3
curl -sfL https://get.k3s.io | K3S_URL=https://swfs-01:6443 K3S_TOKEN=$SECRET sh -s - server --server https://swfs-01:6443 --disable traefik --write-kubeconfig-mode 644


# server node 2 + 3 (cilium)
curl -sfL https://get.k3s.io | K3S_URL=https://swfs-01:6443 K3S_TOKEN=$SECRET sh -s - server --server https://swfs-01:6443 --disable traefik --write-kubeconfig-mode 644 --flannel-backend=none --no-flannel

# agent node
# TBD

# agent node (cilium)
# TBD
curl -sfL https://get.k3s.io | K3S_URL=https://swfs-01:6443 K3S_TOKEN=$SECRET sh -s - --server https://swfs-01:6443 --disable traefik --write-kubeconfig-mode 644 --no-flannel --disable-network-policy

# README 
# => https://docs.k3s.io/cluster-access
# => https://docs.k3s.io/upgrades/automated
# => https://docs.k3s.io/storage (nice to know, but i think we dont need / use it.)
#

