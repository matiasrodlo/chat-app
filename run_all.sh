#!/bin/bash

# Kill any existing Node.js processes
pkill -f node

# Start the Node.js WebSocket server in the background
echo "Starting Node.js WebSocket server..."
npm start &

# Save the PID so we can kill it later if needed
NODE_PID=$!

# Wait a bit to ensure the server starts
sleep 2

# Start the Flutter app in Chrome
echo "Starting Flutter app in Chrome..."
flutter run -d chrome

# When Flutter exits, kill the Node.js server
echo "Stopping Node.js WebSocket server..."
kill $NODE_PID 