#!/bin/bash

# Clear terminal for better readability
clear

case $1 in
  "android")
    echo "📱 Building Android APK..."
    # Clean build first
    flutter clean
    # Get dependencies
    flutter pub get
    # Build release APK with split-per-abi to reduce APK size
    flutter build apk --release --split-per-abi
    echo "✅ APKs built successfully!"
    echo "Location: build/app/outputs/flutter-apk/"
    echo " - app-armeabi-v7a-release.apk"
    echo " - app-arm64-v8a-release.apk"
    echo " - app-x86_64-release.apk"
    ;;
  "ios")
    echo "🍎 Building iOS..."
    flutter build ios --no-codesign
    echo "✅ iOS build completed!"
    ;;
  *)
    echo "Usage: ./build.sh [android|ios]"
    echo "  android: Build release APK (split per ABI)"
    echo "  ios: Build iOS without codesign"
    ;;
esac
