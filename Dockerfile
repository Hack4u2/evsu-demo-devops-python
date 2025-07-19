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
RUN adduser --disabled-password --gecos '' appuser && \
    mkdir -p /app && chown -R appuser:appuser /app

# Cambiar al usuario sin privilegios
USER appuser

# Copiar e instalar dependencias
COPY --chown=appuser:appuser requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copiar e instalar dependencias de desarrollo si existen
COPY --chown=appuser:appuser requirements-dev.txt ./
RUN if [ -f requirements-dev.txt ]; then pip install -r requirements-dev.txt; fi

# Copiar todo el código fuente
COPY --chown=appuser:appuser . .

# Exponer el puerto configurado
EXPOSE ${PORT}

# Healthcheck a endpoint existente
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD curl --fail http://localhost:${PORT}/health/ || exit 1

# Comando por defecto: Ejecuta migraciones y luego inicia Gunicorn
CMD ["sh", "-c", "python manage.py migrate --noinput && gunicorn demo.wsgi:application --bind 0.0.0.0:${PORT}"]
