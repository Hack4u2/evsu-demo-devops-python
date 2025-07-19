#!/bin/bash
set -e

echo "📦 Aplicando configuración de Kubernetes..."

# Forzar el contexto de Minikube
kubectl config use-context minikube

echo "🔍 Verificando acceso al cluster..."
if ! kubectl version --client &>/dev/null; then
  echo "❌ No se pudo acceder al cluster. Revisa si Minikube está corriendo con 'minikube status'."
  exit 1
fi

echo "🚀 Aplicando manifiestos YAML..."
kubectl apply -f k8s/
