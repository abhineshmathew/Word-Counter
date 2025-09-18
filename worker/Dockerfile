FROM python:3.9-slim

WORKDIR /app

# Install netcat (Debian slim requires netcat-openbsd or netcat-traditional)
RUN apt-get update && apt-get install -y netcat-openbsd && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir redis psycopg2-binary

# Copy app code
COPY worker.py .

# Copy entrypoint
COPY worker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/worker-entrypoint.sh

ENTRYPOINT ["worker-entrypoint.sh"]
CMD ["python", "worker.py"]
