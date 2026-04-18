# CFC Members Portal - Flutter App

A simple Flutter mobile application that provides access to the Couples for Christ Members Portal through a WebView.

## Features

- WebView integration to access the CFC Members Portal
- Navigation controls (back, forward, refresh)
- Loading indicator
- Material Design 3 UI

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio / Xcode (for iOS)
- Android SDK / Xcode Command Line Tools

## Setup Instructions

1. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run on Android:**
   ```bash
   flutter run
   ```

3. **Run on iOS:**
   ```bash
   flutter run
   ```
   (Note: iOS development requires a Mac and Xcode)

## Project Structure

- `lib/main.dart` - Main application code with WebView implementation
- `android/` - Android-specific configuration
- `ios/` - iOS-specific configuration
- `pubspec.yaml` - Flutter dependencies

## Dependencies

- `webview_flutter` - WebView plugin for Flutter
- `webview_flutter_android` - Android implementation
- `webview_flutter_wkwebview` - iOS implementation

## Notes

- The app loads the CFC Members Portal login page by default
- Internet permission is required for the app to function
- The WebView supports JavaScript and modern web features
