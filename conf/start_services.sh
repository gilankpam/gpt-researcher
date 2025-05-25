#!/bin/bash

# Function to handle signals and propagate to children
handle_signal() {
    echo "Received signal, stopping services..."
    kill -TERM $backend_pid $frontend_pid 2>/dev/null
    wait $backend_pid $frontend_pid
    exit 0
}

# Trap signals
trap handle_signal SIGTERM SIGINT

# Start backend service
cd /usr/src/app
uvicorn main:app --host 0.0.0.0 --port 8000 &
backend_pid=$!

# Start frontend service
cd /usr/src/frontend
npm start -- --hostname 0.0.0.0 &
frontend_pid=$!

# Wait for processes to complete
wait $backend_pid $frontend_pid
