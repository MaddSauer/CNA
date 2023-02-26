#!/usr/bin/env bash
#
# 2023-02-26 madd init

# reference: https://rpi4cluster.com/monitoring/k3s-prometheus-oper/
mkdir prometheus-operator
cd prometheus-operator
wget https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/master/bundle.yaml
sed -i 's/namespace: default/namespace: monitoring/g' bundle.yaml
kubectl create namespace monitoring
kubectl apply --server-side -f bundle.yaml
