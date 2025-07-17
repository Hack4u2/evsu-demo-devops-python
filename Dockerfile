# Imagen base ligera con Python 3.11
FROM python:3.11-slim

# Establece variables de entorno
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

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
    netcat \
    libssl-dev \
    libffi-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copia el archivo de requerimientos y lo instala
COPY requirements.txt .

RUN pip install --upgrade pip && pip install -r requirements.txt

# Copia el resto del código del proyecto
COPY . .

# Expone el puerto de Django
EXPOSE 8000

# Comando por defecto para ejecutar el servidor
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
