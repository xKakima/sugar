#!/bin/bash

case $1 in
  "android")
    flutter run -d emulator-5554
    ;;
  "ios")
    flutter run -d BC4BA6BB-F1B1-4E55-A9B3-CEDC76F8DD61
    ;;
  *)
    echo "Usage: ./run.sh [android|ios]"
    ;;
esac
