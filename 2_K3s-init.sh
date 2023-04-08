#!/usr/bin/env bash
#
# 2023-02-26  madd  init
# 2023-04-08  madd  changed a should be state - not tested
#

# server node 1
curl -sfL https://get.k3s.io | sh -s - server --cluster-init --disable traefik --write-kubeconfig-mode 644

# server node 1 (cilium)
curl -sfL https://get.k3s.io | sh -s - server --server --cluster-init  https://$HOSTNAME:6443 \
  --tls-san $publicDnsName \
  --tls-san $publicIP \
  --disable traefik \
  --write-kubeconfig-mode 644 \
  --flannel-backend=none \
  --disable flannel \
  --disable-network-policy

# example:
# curl -sfL https://get.k3s.io | sh -s - server --server --cluster-init  https://devobssecops-01:6443 --tls-san doso01.cna.madd-sauer.cloud --tls-san 193.148.166.50 --disable traefik --write-kubeconfig-mode 644 --flannel-backend=none --disable flannel --disable-network-policy

CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/master/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

cilium install

cilium status --wait

# ingress controller
# - disable traefik
# - install ingress nginx

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml


# --------------------
# add additional nodes
# --------------------

# server node 2 + 3
curl -sfL https://get.k3s.io | K3S_TOKEN=$SECRET sh -s - server --server https://swfs-01:6443 --disable traefik --write-kubeconfig-mode 644


# server node 2 + 3 (cilium)
curl -sfL https://get.k3s.io | sh -s - server --server --cluster-init https://$HOSTNAME:6443 --disable traefik --write-kubeconfig-mode 644 --flannel-backend=none --disable flannel --tls-san $publicIP --tls-san $publicHostname

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

