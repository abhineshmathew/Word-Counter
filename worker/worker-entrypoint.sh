#!/bin/sh
set -e

echo "Waiting for db to be ready..."
until nc -z db 5432; do
  sleep 2
done

echo "DB is up - starting worker"
exec python worker.py
