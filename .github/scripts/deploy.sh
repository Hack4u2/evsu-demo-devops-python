#!/bin/bash
set -e

echo "📦 Aplicando configuración de Kubernetes..."

# Se asume que kubectl ya está configurado para el clúster GKE por los pasos previos del workflow.

echo "🔍 Verificando acceso al cluster GKE..."
if ! kubectl version --client &>/dev/null; then
  echo "❌ No se pudo acceder al cluster GKE. Asegúrate de que las credenciales son correctas."
  exit 1
fi

echo "🚀 Aplicando manifiestos YAML..."
kubectl apply -f k8s/

echo "✅ Configuración aplicada con éxito en GKE."
