#!/bin/bash

set -e  # Detener ejecución si algo falla

PROJECT_NAME="devsu-demo-devops-python"
VENV_DIR="venv"

echo "🔧 Iniciando configuración del entorno para $PROJECT_NAME"

# Verifica si estás en la raíz del proyecto
if [[ ! -f "manage.py" ]]; then
  echo "❌ Error: Este script debe ejecutarse desde la raíz del proyecto (donde está manage.py)."
  exit 1
fi

# Crear entorno virtual si no existe
if [[ ! -d "$VENV_DIR" ]]; then
  echo "📦 Creando entorno virtual..."
  python3 -m venv "$VENV_DIR"
else
  echo "✅ Entorno virtual ya existe."
fi

# Activar entorno virtual
source "$VENV_DIR/bin/activate"
echo "🟢 Entorno virtual activado."

# Verificar si requirements.txt existe
if [[ ! -f "requirements.txt" ]]; then
  echo "⚠️  Advertencia: No se encontró requirements.txt. ¿Estás seguro que es un proyecto Django?"
else
  echo "⬇️ Instalando dependencias..."
  pip install --upgrade pip
  pip install -r requirements.txt
fi

# Crear archivo .env.example si no existe
if [[ ! -f ".env" && ! -f ".env.example" ]]; then
  echo "🔐 Creando archivo .env.example..."
  cat <<EOF > .env.example
DEBUG=True
SECRET_KEY=changeme
ALLOWED_HOSTS=localhost,127.0.0.1
DB_NAME=yourdbname
DB_USER=yourdbuser
DB_PASSWORD=yourdbpass
DB_HOST=localhost
DB_PORT=5432
EOF
  echo "📝 .env.example creado. Recuerda completar tu archivo .env real."
fi

# Aplicar migraciones
echo "🔄 Ejecutando migraciones de base de datos..."
python manage.py migrate

# Crear superusuario (opcional)
read -p "¿Deseas crear un superusuario ahora? (s/n): " CREATE_SUPERUSER
if [[ "$CREATE_SUPERUSER" == "s" ]]; then
  python manage.py createsuperuser
fi

# Verificar si hay errores antes de correr
echo "🧪 Verificando errores con check..."
python manage.py check

# Ejecutar servidor
echo "🚀 Iniciando servidor local..."
python manage.py runserver
