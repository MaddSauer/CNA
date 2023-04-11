#!/usr/bin/env bash
# Vault tuff ...

#sudo -i

#include rpm source hashicorp
dnf -y install vault

mkdir -p /etc/vault.d/certs/
echo >> /etc/vault.d/vault.hcl <<<EOF
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_cert_file = "/etc/vault.d/certs/vault_cert.pem"
  tls_key_file = "/etc/vault.d/certs/vault_key.pem"
}
EOF

sudo systemctl enable --now vault

export VAULT_ADDR='https://127.0.0.1:8200'

# only the first time
vault operator init
# save the output somewhere

###
# a lot of stuff happening ...
###

kubectl get secrets --all-namespaces -o json > k8s-secrets.json

cat k8s-secrets.json | jq '.items | map(select(.metadata.name | contains("default-token") | not))' > filtered-k8s-secrets.json

vault login $VAULT_TOKEN

vault-k8s-migrator import filtered-k8s-secrets.json secret/data/k8s

echo > vault-agent-injector_example.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  template:
    metadata:
      annotations:
        vault.hashicorp.com/agent-inject: "true"
        vault.hashicorp.com/agent-inject-secret-<SECRET_NAME>: "secret/data/k8s/<NAMESPACE>/<SECRET_NAME>"
        vault.hashicorp.com/agent-inject-template-<SECRET_NAME>: |
          {{- with secret "secret/data/k8s/<NAMESPACE>/<SECRET_NAME>" -}}
          {{ range $k, $v := .Data.data }}
          {{ $k }}: {{ $v }}
          {{ end }}
          {{- end }}
      spec:
        serviceAccountName: vault-auth
        containers:
        - name: myapp
          image: myapp:latest

EOF

# delete the old secret
kubectl delete secret -n <NAMESPACE> <SECRET_NAME>


