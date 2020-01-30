#!/bin/bash
set -eux -o pipefail

kubectl apply -f guides/k8s/olm/namespace.yaml

kubectl apply -f guides/k8s/olm/catalog-source.yaml
kubectl wait pod -n olm -l olm.catalogSource=argocd-catalog --for=condition=Ready --timeout=60s

kubectl apply -f guides/k8s/olm/operator-group.yaml
kubectl apply -f guides/k8s/olm/subscription.yaml

sleep 30

kubectl wait pod -n argocd -l name=argocd-operator-helm --for=condition=Ready --timeout=30s
kubectl rollout status -w deployment/argocd-operator-helm -n argocd


kubectl delete -f guides/k8s/olm/subscription.yaml
kubectl delete csv argocd-operator-helm.v0.0.4 -n argocd
kubectl delete crd argocds.argoproj.io
kubectl delete -f guides/k8s/olm/catalog-source.yaml
kubectl delete -f guides/k8s/olm/operator-group.yaml
kubectl delete -f guides/k8s/olm/namespace.yaml


kubectl apply -f guides/k8s/manual/namespace.yaml
kubectl apply -f guides/k8s/manual/service-account.yaml
kubectl apply -f guides/k8s/manual/role.yaml
kubectl apply -f guides/k8s/manual/role-binding.yaml
kubectl apply -f guides/k8s/manual/crd.yaml
kubectl apply -f guides/k8s/manual/deployment.yaml

kubectl wait pod -n argocd -l name=argocd-operator-helm --for=condition=Ready --timeout=30s
kubectl rollout status -w deployment/argocd-operator-helm -n argocd

kubectl delete -f guides/k8s/manual/deployment.yaml
kubectl delete -f guides/k8s/manual/crd.yaml
kubectl delete -f guides/k8s/manual/role-binding.yaml
kubectl delete -f guides/k8s/manual/role.yaml
kubectl delete -f guides/k8s/manual/service-account.yaml
kubectl delete -f guides/k8s/manual/namespace.yaml
