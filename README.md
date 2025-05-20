# Chat App

A real-time chat application built with Flutter and WebSocket, featuring local network communication and modern UI.

## Features

- Real-time messaging using WebSocket
- Local network communication
- Message delivery status tracking
- Offline message queue
- Clean architecture implementation
- Modern and responsive UI
- User authentication
- Specialist/User chat functionality

## Architecture

The project follows clean architecture principles with the following structure:

```
lib/
├── core/           # Core functionality and configurations
├── features/       # Feature modules
│   ├── auth/      # Authentication feature
│   ├── chat/      # Chat feature
│   └── specialist/# Specialist feature
├── shared/        # Shared utilities and services
└── services/      # Core services
```

## Prerequisites

- Flutter SDK (latest stable version)
- Node.js (for WebSocket server)
- Dart SDK
- VS Code (recommended) or Android Studio

## Setup

1. Clone the repository:
```bash
git clone [repository-url]
cd chat-app
```

2. Install Flutter dependencies:
```bash
flutter pub get
```

3. Install Node.js dependencies:
```bash
npm install ws
```

4. Start the application:
```bash
./run_all.sh
```

This script will:
- Start the WebSocket server on port 8080
- Launch the Flutter web app in Chrome

## Development

### Project Structure

- `lib/core/`: Core configurations, themes, and routes
- `lib/features/`: Feature-based modules
- `lib/services/`: Core services implementation
- `lib/shared/`: Shared utilities and widgets
- `server.js`: WebSocket server implementation

### Key Components

- **WebSocket Service**: Handles real-time communication
- **Chat Service**: Manages chat functionality
- **Local Service**: Handles local data persistence
- **Specialist Service**: Manages specialist-related features

### Troubleshooting

1. If you see "Error: unable to find directory entry in pubspec.yaml: assets/images/":
   - Create an `assets/images` directory in your project root
   - Add the directory to your `pubspec.yaml` under the `flutter` section:
     ```yaml
     flutter:
       assets:
         - assets/images/
     ```

2. If the WebSocket connection fails:
   - Ensure the Node.js server is running (`node server.js`)
   - Check that port 8080 is not in use
   - Verify that the WebSocket URL is correct (ws://127.0.0.1:8080)

3. If the Flutter app fails to start:
   - Run `flutter clean`
   - Run `flutter pub get`
   - Try running the app again

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- WebSocket community for the real-time communication protocols
- All contributors who have helped shape this project

## Contact

For any questions or concerns, please open an issue in the repository.
