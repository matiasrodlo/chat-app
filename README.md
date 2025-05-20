# Chat App

A Flutter-based chat application that allows users to communicate with specialists. The app features user authentication, real-time messaging, and a clean, modern UI.

## Features

- **User Authentication**
  - Registration with email and password
  - Login functionality
  - Session management
  - Secure local storage of user data

- **Chat Functionality**
  - Real-time messaging with specialists
  - Message history
  - Chat list view
  - Message status indicators

- **Specialist Integration**
  - List of available specialists
  - Specialist profiles
  - Direct messaging with specialists

- **Local Storage**
  - Secure storage of user data
  - Message history persistence
  - Offline capability

## Screenshots

<p>
  <a href="#">
    <img src="https://github-production-user-asset-6210df.s3.amazonaws.com/52969662/282580282-1db8948e-7e07-40af-bcfc-ec397e1762d1.png" alt="Chat Interface">
  </a>
</p>

<p>
  <a href="#">
    <img src="https://github-production-user-asset-6210df.s3.amazonaws.com/52969662/282580557-9c79fe39-1897-49c6-8bf0-d4ad5f711586.png" alt="User Profile">
  </a>
</p>

<p>
  <a href="#">
    <img src="https://github-production-user-asset-6210df.s3.amazonaws.com/52969662/282579204-a206f852-5ae1-4f0b-b049-4dc6c0e29587.png" alt="Settings">
  </a>
</p>

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK (latest version)
- Android Studio / VS Code with Flutter extensions
- Chrome browser (for web development)

### Installation

1. Clone the repository:
```bash
git clone [repository-url]
cd chat-app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── classes/           # Data models
├── config/           # Configuration files
├── helpers/          # Helper utilities
├── pages/            # UI screens
├── services/         # Business logic
└── widgets/          # Reusable UI components
```

## Architecture

The app follows a clean architecture pattern:

- **Services Layer**: Handles business logic and data operations
  - `LocalService`: Manages local storage and data persistence
  - `WebSocketService`: Handles real-time communication
  - `ServiceUsers`: Manages user authentication and session

- **UI Layer**: Implements the user interface
  - Pages for different screens
  - Reusable widgets
  - Navigation and routing

## Development

### Local Development

The app is configured for local development with:
- Local storage for user data
- Mock specialists data
- No-op WebSocket service for testing

### Building for Production

To build the app for production:

```bash
flutter build web
```

## Dependencies

- `carousel_slider`: ^3.0.0 - For image carousels
- `http`: ^0.13.3 - For API requests
- `shared_preferences`: ^2.0.6 - For local storage
- `flutter_pusher`: ^1.0.2 - For real-time features
- `intl`: ^0.17.0 - For internationalization
- `url_launcher`: ^6.0.9 - For opening URLs
- `font_awesome_flutter`: ^9.1.0 - For icons

## Configuration

The app requires the following configuration:

1. Pusher credentials for real-time messaging
2. API endpoints for backend communication
3. Storage configuration for media files

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Contributors and maintainers
- Open source community

## Contact

For any questions or concerns, please open an issue in the repository.
