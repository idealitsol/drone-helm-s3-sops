#!/bin/bash

echo ${KUBERNETES_SERVER}
echo ${KUBERNETES_TOKEN}
echo $KUBERNETES_SERVER
echo $KUBERNETES_TOKEN

if [[ ! -z ${KUBERNETES_TOKEN} ]]; then
  KUBERNETES_TOKEN=${KUBERNETES_TOKEN}
fi

if [[ ! -z ${KUBERNETES_SERVER} ]]; then
  KUBERNETES_SERVER=${KUBERNETES_SERVER}
fi

if [[ ! -z ${KUBERNETES_CERT} ]]; then
  KUBERNETES_CERT=${KUBERNETES_CERT}
fi

kubectl config set-credentials default --token=${KUBERNETES_TOKEN}
if [[ ! -z ${KUBERNETES_CERT} ]]; then
  echo ${KUBERNETES_CERT} | base64 -d >ca.crt
  kubectl config set-cluster default --server=${KUBERNETES_SERVER} --certificate-authority=ca.crt
else
  echo "WARNING: Using insecure connection to cluster"
  kubectl config set-cluster default --server=${KUBERNETES_SERVER} --insecure-skip-tls-verify=true
fi

kubectl config set-context default --cluster=default --user=default
kubectl config use-context default

kubectl config view

# Run helm command
if [[ ! -z ${PLUGIN_HELM} ]]; then
  helm ${PLUGIN_HELM}
fi
