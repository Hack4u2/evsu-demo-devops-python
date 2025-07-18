# Imagen base ligera con Python 3.11
FROM python:3.11-slim

# Variables de entorno seguras por defecto
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8000

# Establece el directorio de trabajo
WORKDIR /app

# Instala dependencias del sistema
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libsqlite3-dev \
    curl \
    sqlite3 \
    netcat-openbsd \
    libssl-dev \
    libffi-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario sin privilegios
RUN adduser --disabled-password --gecos '' appuser
USER appuser

# Copiar e instalar dependencias
COPY --chown=appuser:appuser requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copiar todo el código
COPY --chown=appuser:appuser . .

# Exponer puerto configurable
EXPOSE ${PORT}

# Healthcheck sencillo (requiere endpoint saludable en Django como /health/)
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD curl --fail http://localhost:${PORT}/ || exit 1

# Comando por defecto
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
