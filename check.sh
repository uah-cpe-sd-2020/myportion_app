#!/bin/sh

# Format the code
flutter format lib

# Get depends
flutter pub get

# Audit Code
flutter analyze

# Run Unit Tests and generate coverage report
flutter test --coverage

# Form coverage into HTML output
genhtml coverage/lcov.info --output-directory coverage/html
