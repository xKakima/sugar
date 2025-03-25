#!/bin/bash

# Clear terminal for better readability
clear

case $1 in
  "android")
    BUILD_TYPE=${2:-"release"}
    echo "📱 Building Android APK in ${BUILD_TYPE} mode..."
    # Clean build first
    flutter clean
    # Get dependencies
    flutter pub get
    
    if [ "$BUILD_TYPE" = "debug" ]; then
      # Build debug APK
      flutter build apk --debug
      if [ $? -eq 0 ]; then
        echo "✅ Debug APK built successfully!"
        echo "Location: build/app/outputs/flutter-apk/app-debug.apk"
      else
        echo "❌ Debug build failed!"
        exit 1
      fi
    else
      # Build release APK without splitting
      flutter build apk --release
      if [ $? -eq 0 ]; then
        echo "✅ Release APK built successfully!"
        echo "Location: build/app/outputs/flutter-apk/app-release.apk"
      else
        echo "❌ Release build failed!"
        exit 1
      fi
    fi
    ;;
  "ios")
    echo "🍎 Building iOS..."
    flutter build ios --no-codesign
    echo "✅ iOS build completed!"
    echo "Location: build/ios/iphoneos/Runner.ipa"
    ;;
  *)
    echo "Usage: ./build.sh [android|ios]"
    echo "  android: Build release APK (split per ABI)"
    echo "  ios: Build iOS without codesign"
    ;;
esac
