kk#!/bin/bash
set -e

echo "📦 Aplicando configuración de Kubernetes..."

echo "🔍 Verificando acceso al cluster GKE..."
if ! kubectl version --client &>/dev/null; then
  echo "❌ No se pudo acceder al cluster GKE. Asegúrate de que las credenciales son correctas."
  exit 1
fi

echo "🚀 Aplicando manifiestos YAML..."
# Asumiendo que k8s/00-namespace.yaml se procesará primero
kubectl apply -f k8s/

echo "✅ Configuración aplicada con éxito en GKE."
