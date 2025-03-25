#!/bin/bash

# Clear the terminal for better readability
clear

# Navigate to project root directory
cd "$(dirname "$0")" || exit 1

# Check if the build directory exists
if [ ! -d "build/ios/iphoneos" ]; then
    echo "❌ Error: build/ios/iphoneos directory not found. Please run 'flutter build ios' first."
    exit 1
fi

# Navigate to ios/iphoneos directory
cd "build/ios/iphoneos" || exit 1

# Clean up previous files
rm -rf Payload Runner.ipa

# Create Payload directory (this is required for iOS apps)
mkdir -p Payload

# Look for Runner.app in possible locations
runner_app_locations=(
    "./Runner.app"
    "../Runner.app"
    "../../Runner.app"
)

runner_app_found=false
for location in "${runner_app_locations[@]}"; do
    if [ -d "$location" ]; then
        echo "📱 Found Runner.app at $location"
        # Copy directly to Payload directory (this is the correct structure)
        cp -R "$location" Payload/
        runner_app_found=true
        break
    fi
done

if [ "$runner_app_found" = false ]; then
    echo "❌ Error: Runner.app not found. Please ensure the app was built successfully."
    exit 1
fi

# Create zip file with Payload directory (this is the correct iOS app structure)
echo "📦 Creating IPA file..."
zip -qr Runner.ipa Payload

# Clean up
rm -rf Payload

echo "✅ IPA file created successfully at build/ios/iphoneos/Runner.ipa"
echo "ℹ️  The IPA file is now properly structured for Sideloadly"
