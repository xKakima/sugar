#!/bin/bash

# Clear the terminal for better readability
clear

# Navigate to ios/iphoneos directory
cd "$(dirname "$0")/build/ios/iphoneos" || exit 1

# Remove Runner directory if it exists
if [ -d "Runner" ]; then
    rm -rf Runner
fi

# Create Runner directory
mkdir -p Runner

# Move Runner file from /ios/iphoneos to /ios/iphoneos/Runner
mv ../Runner Runner/

# Create zip file
zip -r Runner.zip Runner

# Rename zip to ipa
mv Runner.zip Runner.ipa

echo "✅ IPA file created successfully at ios/iphoneos/Runner.ipa"
