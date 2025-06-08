# Calendar App 📅

A modern, interactive calendar application built with Flutter and Firebase, designed for easy event management and collaboration.

## ✨ Features

- 🔐 **Authentication**
  - Email/password login
  - Guest mode access
  - User profile management

- 📅 **Calendar Management**
  - Multiple view modes (month/week/day)
  - Event creation and editing
  - Color-coded events
  - Real-time updates

- 💾 **Data Persistence**
  - Cloud storage with Firestore
  - Offline capability
  - Data synchronization

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Firebase account
- VS Code or Android Studio

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/KirilBK/Calendatora
   cd Calendatora
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a project in [Firebase Console](https://console.firebase.google.com/)
   - Enable required services:
     - Authentication
     - Cloud Firestore
   - Download configuration files:
     ```bash
     # For Android
     Place google-services.json in android/app/
     
    

4. **Run the application**
   ```bash
   flutter run
   ```

## 🏗️ Architecture

### Data Models

#### User Schema
```json
{
  "uid": "string",
  "email": "string",
  "name": "string",
  "createdAt": "timestamp"
}
```

#### Event Schema
```json
{
  "id": "string",
  "title": "string",
  "description": "string?",
  "startTime": "timestamp",
  "endTime": "timestamp",
  "createdBy": "string (user_id)",
  "color": "string (hex)",
  "createdAt": "timestamp"
}
```

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the project root:
```env
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id
```

### Firebase Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📱 Supported Platforms

- ✅ Android
- ✅ Web

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Flutter Setup](https://firebase.flutter.dev/docs/overview/)
- [Provider Package](https://pub.dev/packages/provider)
- [Table Calendar](https://pub.dev/packages/table_calendar)

## 📄 License

This project is licensed under the MIT License

## 🐛 Known Issues

- Guest mode has limited functionality
- Calendar sync may delay in poor network conditions

