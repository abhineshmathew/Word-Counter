# Word Counter

A simple, yet robust app for submitting text and counting/storing words via a worker and message broker/DB architecture. Built with Flask, Redis, and PostgreSQL microservices.

---

## Table of Contents

- [Features](#features)  
- [Architecture](#architecture)  
- [Getting Started](#getting-started)  
  - [Prerequisites](#prerequisites)  
  - [Project Structure](#project-structure)  
  - [Setup & Run](#setup--run)  
- [Usage](#usage)  
- [Configuration](#configuration)  
- [Troubleshooting](#troubleshooting)  
- [Future Improvements](#future-improvements)  
- [License](#license)

---

## Features

- Frontend web interface to submit text  
- Worker service to process submitted text asynchronously  
- Use of Redis for quick queue handling  
- Use of PostgreSQL for persistence & more complex operations  
- Dockerized setup with `docker-compose` for easy local development  

---

## Architecture

Here’s a high-level overview of how the components interact:

| Component | Responsibility |
|-----------|----------------|
| **Frontend** | Flask application that renders a form for text input, submits text to backend/queues and displays the result or status. |
| **Worker** | Listens to a queue (via Redis), pulls tasks, processes text (word count or further logic), and stores results in PostgreSQL. |
| **Redis** | Message broker / queue for decoupling frontend and worker. |
| **PostgreSQL (db)** | Persistence layer for any results or advanced analytics. |

Components are connected via Docker networking in `docker-compose`. Dependencies are dynamically handled so worker waits until the database is available before running.

---

## Getting Started

### Prerequisites

You’ll need the following installed:

- [Docker](https://www.docker.com/)  
- [Docker Compose](https://docs.docker.com/compose/)  
- Git (to clone the repository)  

### Project Structure

Here’s the typical directory layout:

```
Word‑Counter/
├── frontend/             # Flask app for user input
│   ├── Dockerfile
│   └── app.py
├── worker/               # Worker service
│   ├── Dockerfile
│   ├── worker.py
│   └── worker-entrypoint.sh
├── docker-compose.yaml   # Or docker-compose.yml
└── README.md             # You are here
```

---

### Setup & Run

1. **Clone the repository**

   ```bash
   git clone https://github.com/abhineshmathew/Word‑Counter.git
   cd Word‑Counter
   ```

2. **Build and start services**

   To build and start all services (frontend, worker, Redis, PostgreSQL):

   ```bash
   docker-compose up --build
   ```

3. **Service-specific build**

   To rebuild only one service (say `worker`), do:

   ```bash
   docker-compose build worker
   ```

   or to start just that service with rebuild:

   ```bash
   docker-compose up --build worker
   ```

4. **Accessing the frontend**

   Once running, open your browser and go to:

   ```
   http://localhost:5000/
   ```

   (Assumes frontend is mapped to port 5000.)

---

## Usage

- Navigate to the frontend web page.  
- Enter text into the input form and submit.  
- The text is queued via Redis, processed by the worker, and persisted into PostgreSQL (or whatever logic you’ve implemented).  
- You can extend the worker to return the word count or other metrics.  

---

## Configuration

You may want to configure:

| Environment | Description |
|-------------|-------------|
| `db` host/user/password | For PostgreSQL credentials in the worker and possibly frontend if needed. |
| Redis connection settings | Host, port, and optional password (if using secured Redis). |
| Docker network settings | Ensuring services are on the same Docker network so that hostnames (like `db`, `redis`) resolve properly. |

These settings can be adjusted in `docker-compose.yaml` and in service files (`worker.py`, `frontend/app.py`) as needed.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Worker logs show `connection refused` to `db` | Ensure PostgreSQL container is running and healthy. Use `depends_on` and, optionally, a waiting script or retry loop so the worker doesn’t start too early. |
| Frontend exits immediately | Check for typos (e.g. `__main__`) in app startup code. Ensure Flask is commanded correctly in the Dockerfile (with correct host and port). |
| Permission denied to access Docker | Make sure your user is added to the `docker` group and you’ve logged out/login or restarted your terminal session. |

---

## Future Improvements

- Add authentication so only authorized users can submit text.  
- Make the worker support multiple tasks: e.g. word count, character count, readability metrics.  
- Add a UI to view past submissions and their counts.  
- Health checks for services (especially db and redis) for production readiness.  
- Container orchestration / deployment scripts (e.g., Kubernetes or managed cloud).  

---

## License

_Include your license here, e.g., MIT, Apache‑2.0, etc._

---

*Built with ❤️ by Abhinesh*
