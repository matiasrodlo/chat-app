const WebSocket = require('ws');

// Create server with error handling
const server = new WebSocket.Server({ 
  port: 8080,
  host: '0.0.0.0'  // Listen on all network interfaces
});

// Store all connected clients
const clients = new Set();
// Store message history for pagination
const messageHistory = [];
const MAX_HISTORY = 100;
// Store processed message IDs to prevent duplicates
const processedMessageIds = new Set();
// Store client-specific message IDs to prevent duplicates per client
const clientMessageIds = new Map();

// Handle server errors
server.on('error', (error) => {
  if (error.code === 'EADDRINUSE') {
    console.error('Port 8080 is already in use. Please make sure no other instance is running.');
    process.exit(1);
  } else {
    console.error('Server error:', error);
  }
});

server.on('connection', (ws) => {
  // Add new client to the set
  clients.add(ws);
  // Initialize client's message ID set
  clientMessageIds.set(ws, new Set());
  console.log('Client connected. Total clients:', clients.size);

  // Send recent message history to new client
  if (messageHistory.length > 0) {
    const recentMessages = messageHistory.slice(-20); // Send last 20 messages
    ws.send(JSON.stringify({
      type: 'history',
      messages: recentMessages
    }));
  }

  // Broadcast the new client count to all clients
  broadcastClientCount();

  ws.on('message', (message) => {
    try {
      const data = JSON.parse(message);
      
      if (data.type === 'reaction') {
        // Handle reaction
        handleReaction(data, ws);
      } else if (data.type === 'delivery') {
        // Handle delivery confirmation
        handleDeliveryConfirmation(data, ws);
      } else {
        // Handle regular message
        handleMessage(data, ws);
      }
    } catch (e) {
      console.error('Error processing message:', e);
    }
  });

  ws.on('close', () => {
    // Remove client from the set
    clients.delete(ws);
    // Clean up client's message IDs
    clientMessageIds.delete(ws);
    console.log('Client disconnected. Total clients:', clients.size);
    // Broadcast the new client count
    broadcastClientCount();
  });
});

function handleMessage(data, sender) {
  // Get client's message ID set
  const clientIds = clientMessageIds.get(sender);
  
  // Check if this client has already processed this message
  if (clientIds && clientIds.has(data.id)) {
    return;
  }

  // Check if we've already processed this message globally
  if (processedMessageIds.has(data.id)) {
    // Add to client's processed IDs
    if (clientIds) {
      clientIds.add(data.id);
    }
    return;
  }

  // Add message ID to processed sets
  processedMessageIds.add(data.id);
  if (clientIds) {
    clientIds.add(data.id);
  }

  // Add message to history
  messageHistory.push(data);
  if (messageHistory.length > MAX_HISTORY) {
    messageHistory.shift(); // Remove oldest message
  }

  // Broadcast the message to all clients except the sender
  clients.forEach((client) => {
    if (client !== sender && client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify(data));
    }
  });

  // Send delivery confirmation to sender
  if (sender.readyState === WebSocket.OPEN) {
    sender.send(JSON.stringify({
      type: 'delivery',
      messageId: data.id
    }));
  }

  // Clean up old message IDs periodically
  if (processedMessageIds.size > MAX_HISTORY * 2) {
    const oldIds = Array.from(processedMessageIds).slice(0, processedMessageIds.size - MAX_HISTORY);
    oldIds.forEach(id => {
      processedMessageIds.delete(id);
      // Also clean up from client sets
      clientMessageIds.forEach(clientSet => clientSet.delete(id));
    });
  }
}

function handleDeliveryConfirmation(data, sender) {
  // Broadcast the delivery confirmation to all clients
  clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify(data));
    }
  });
}

function handleReaction(data, sender) {
  // Broadcast the reaction to all clients
  clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify(data));
    }
  });
}

function broadcastClientCount() {
  const count = clients.size;
  const message = JSON.stringify({ type: 'count', count });
  clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(message);
    }
  });
}

// Handle process termination
process.on('SIGINT', () => {
  console.log('Shutting down server...');
  server.close(() => {
    console.log('Server closed');
    process.exit(0);
  });
});

console.log('WebSocket server is running on port 8080'); 