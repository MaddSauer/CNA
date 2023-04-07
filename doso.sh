
# Storyline:
# installing Cert-Manager

# homebrew installation for Linux (for a more easy deployment of tools)
export NONINTERACTIVE=1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(
  echo
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
) >> /home/fedora/.bash_profile

# install k9s
brew install derailed/k9s/k9s


# install local k3s for development that tools running on k8s
curl -sfL https://get.k3s.io | sh -
sudo systemctl enable --now k3s

# install krew, required for a lot of tools to install plugins
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
(
  echo
  echo 'PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"'
) >> /home/fedora/.bash_profile

# install operator-sdk framework (k8s required)
brew install operator-sdk
export KUBECONFIG=$HOME/.kube/config 
operator-sdk olm install
kubectl krew install operator

# installation guide -> https://cert-manager.io/docs/installation/operator-lifecycle-manager/
# create ns for the certmanager operator because 'operators' is not useable for this one
# start *always* operator namespaces with "operator-" instead using it at the end "-operator"
kubectl create ns operator-cert-manager
kubectl operator install cert-manager -n operator-cert-manager --channel stable --approval Automatic --create-operator-group

# verify
kubectl operator list
kubectl get subscription cert-manager -n operator-cert-manager -o yaml

# install metircs server (e.g. for autoscaling horzontal / vertical )
# already installed in k3s
#helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
#helm upgrade --install metrics-server metrics-server/metrics-server

# install gitlab operator

GL_OPERATOR_VERSION=0.8.1 # https://gitlab.com/gitlab-org/cloud-native/gitlab-operator/-/releases
PLATFORM=kubernetes # or "openshift"
kubectl create namespace gitlab-system
kubectl apply -f https://gitlab.com/api/v4/projects/18899486/packages/generic/gitlab-operator/${GL_OPERATOR_VERSION}/gitlab-operator-${PLATFORM}-${GL_OPERATOR_VERSION}.yaml
