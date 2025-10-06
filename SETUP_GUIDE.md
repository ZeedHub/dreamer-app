# 🌙 Dreamer App - Setup Guide

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (>= 3.0.0) - [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (>= 3.0.0) - Comes with Flutter
- **Android Studio** or **Xcode** (for iOS development)
- **Firebase Account** - [Create Firebase Project](https://console.firebase.google.com)
- **Git** - [Install Git](https://git-scm.com/downloads)

## 🚀 Step 1: Clone the Repository

```bash
git clone https://github.com/ZeedHub/dreamer-app.git
cd dreamer-app
```

## 🔧 Step 2: Install Flutter Dependencies

```bash
flutter pub get
```

## 🔥 Step 3: Firebase Setup

### 3.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add Project"
3. Enter project name: **Dreamer**
4. Enable Google Analytics (optional)
5. Click "Create Project"

### 3.2 Add Android App

1. In Firebase console, click the Android icon
2. Register app with package name: `com.zeedhub.dreamer`
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

### 3.3 Add iOS App

1. In Firebase console, click the iOS icon
2. Register app with bundle ID: `com.zeedhub.dreamer`
3. Download `GoogleService-Info.plist`
4. Place it in: `ios/Runner/GoogleService-Info.plist`

### 3.4 Enable Firebase Services

In Firebase Console, enable:

- **Authentication**
  - Go to Authentication → Sign-in method
  - Enable Email/Password
  - Enable Google Sign-In (optional)

- **Cloud Firestore**
  - Go to Firestore Database
  - Click "Create database"
  - Start in **test mode** (for development)
  - Choose your region

- **Cloud Storage**
  - Go to Storage
  - Click "Get started"
  - Start in **test mode**

- **Firebase Analytics** (optional)
  - Already enabled if you selected it during project creation

### 3.5 Deploy Firestore Rules

```bash
firebase deploy --only firestore:rules
```

## 📱 Step 4: Android Configuration

### 4.1 Update `android/build.gradle`

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

### 4.2 Update `android/app/build.gradle`

Add at the bottom:
```gradle
apply plugin: 'com.google.gms.google-services'
```

Update `minSdkVersion` to 21:
```gradle
android {
    defaultConfig {
        minSdkVersion 21
    }
}
```

## 🍎 Step 5: iOS Configuration

### 5.1 Update `ios/Podfile`

Uncomment this line:
```ruby
platform :ios, '12.0'
```

### 5.2 Install Pods

```bash
cd ios
pod install
cd ..
```

## 🎨 Step 6: Add Assets

### 6.1 Create Asset Directories

```bash
mkdir -p assets/images assets/icons/zodiac assets/icons/symbols assets/animations/lottie assets/fonts
```

### 6.2 Download Poppins Font

1. Visit [Google Fonts - Poppins](https://fonts.google.com/specimen/Poppins)
2. Download the font family
3. Extract and copy these files to `assets/fonts/`:
   - Poppins-Regular.ttf
   - Poppins-Medium.ttf
   - Poppins-SemiBold.ttf
   - Poppins-Bold.ttf

## 🔨 Step 7: Generate Code

Run the code generator for Freezed and JSON Serialization:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## ▶️ Step 8: Run the App

### For Android

```bash
flutter run
```

### For iOS

```bash
flutter run -d ios
```

### For Web

```bash
flutter run -d chrome
```

## 🧪 Step 9: Run Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📦 Step 10: Build Release Version

### Android APK

```bash
flutter build apk --release
```

### Android App Bundle

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## 🗂️ Project Structure Overview

```
lib/
├── main.dart                    # App entry point
├── core/                        # Core functionality
│   ├── config/                  # App configuration
│   ├── constants/               # Constants
│   ├── navigation/              # Routing
│   ├── services/                # Services
│   └── utils/                   # Utilities
│
└── features/                    # Feature modules
    ├── auth/                    # Authentication
    ├── profile/                 # User profiles
    ├── dreams/                  # Dream journaling
    ├── interpretation/          # AI interpretations
    ├── social/                  # Social features
    ├── analytics/               # Dream analytics
    └── home/                    # Home screen
```

## 🔑 Environment Variables

Create a `.env` file in the root directory (already in .gitignore):

```env
# API Keys
OPENAI_API_KEY=your_openai_api_key_here
BACKEND_URL=https://your-backend-url.com/api

# Firebase (optional - can use google-services.json instead)
FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_PROJECT_ID=your_firebase_project_id
FIREBASE_APP_ID=your_firebase_app_id
```

## 🐛 Common Issues & Solutions

### Issue: "google-services.json not found"
**Solution:** Make sure you've downloaded and placed the file in `android/app/`

### Issue: "Pod install failed"
**Solution:** 
```bash
cd ios
pod repo update
pod install --repo-update
cd ..
```

### Issue: "Firebase not initialized"
**Solution:** Ensure Firebase.initializeApp() is called in main.dart before runApp()

### Issue: "Build Runner conflicts"
**Solution:**
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: "Gradle build failed"
**Solution:** 
- Check your Java version (should be Java 11 or higher)
- Clean build: `flutter clean && flutter pub get`

## 📚 Key Dependencies Explained

| Package | Purpose |
|---------|---------|
| `firebase_core` | Firebase initialization |
| `firebase_auth` | User authentication |
| `cloud_firestore` | NoSQL database |
| `firebase_storage` | File storage |
| `flutter_riverpod` | State management |
| `go_router` | Navigation |
| `freezed` | Immutable models |
| `hive` | Local storage |
| `dio` | HTTP client |
| `flutter_quill` | Rich text editor |
| `record` | Audio recording |
| `fl_chart` | Analytics charts |

## 🎯 Next Steps

After setup, you can start developing:

1. **Create Authentication Flow**
   ```bash
   lib/features/auth/presentation/screens/
   ```

2. **Set Up Backend API** (Python FastAPI)
   ```bash
   # In a separate directory
   mkdir dreamer-backend && cd dreamer-backend
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install fastapi uvicorn firebase-admin openai spacy
   ```

3. **Test Firebase Connection**
   - Run the app
   - Try creating a test user
   - Check Firebase Console

4. **Customize Theme**
   - Edit `lib/core/config/theme_config.dart`
   - Change colors to match your brand

5. **Add Your Logo**
   - Place your logo in `assets/images/logo.png`
   - Update splash screen

## 🔒 Security Best Practices

1. **Never commit sensitive files:**
   - `.env` files
   - `google-services.json`
   - `GoogleService-Info.plist`
   - API keys

2. **Use Firebase Security Rules:**
   - Deployed rules are in `firestore.rules`
   - Test rules thoroughly before production

3. **Enable App Check** (Production):
   ```bash
   firebase app-check:setup
   ```

4. **Use environment-specific configs:**
   - Development
   - Staging
   - Production

## 📱 Device Requirements

### Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 33 (Android 13)

### iOS
- Minimum iOS: 12.0
- Xcode: 14.0+

## 🚀 Deployment Checklist

Before releasing to production:

- [ ] Update app version in `pubspec.yaml`
- [ ] Test on real devices (Android & iOS)
- [ ] Configure release signing keys
- [ ] Update Firebase security rules (change from test mode)
- [ ] Enable Firebase App Check
- [ ] Test offline functionality
- [ ] Add proper error handling
- [ ] Set up analytics tracking
- [ ] Create privacy policy
- [ ] Prepare app store assets (screenshots, descriptions)
- [ ] Test payment integration (if applicable)

## 📖 Documentation

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Flutter Setup](https://firebase.google.com/docs/flutter/setup)
- [Riverpod Documentation](https://riverpod.dev/)
- [Go Router Documentation](https://pub.dev/packages/go_router)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📝 Code Style

Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)

Run formatter:
```bash
dart format .
```

Run analyzer:
```bash
flutter analyze
```

## 🐞 Reporting Issues

Found a bug? Please create an issue with:
- Device/OS information
- Steps to reproduce
- Expected vs actual behavior
- Screenshots (if applicable)

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 💡 Tips for Development

1. **Use Hot Reload:** Press `r` in terminal while app is running
2. **Use Hot Restart:** Press `R` for full app restart
3. **Flutter DevTools:** `flutter pub global activate devtools` then `flutter pub global run devtools`
4. **VS Code Extensions:**
   - Flutter
   - Dart
   - Awesome Flutter Snippets
   - Error Lens

## 🎓 Learning Resources

- [Flutter Codelabs](https://flutter.dev/docs/codelabs)
- [Firebase for Flutter](https://firebase.google.com/codelabs/firebase-get-to-know-flutter)
- [Riverpod Examples](https://github.com/rrousselGit/river_pod/tree/master/examples)

## 🌟 Support

Need help? Reach out:
- 📧 Email: support@zeedhub.com
- 💬 Discord: [Join our community](#)
- 🐦 Twitter: [@ZeedHub](#)

---

**Happy Coding! 🚀**
