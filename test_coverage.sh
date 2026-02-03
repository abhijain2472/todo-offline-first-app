#!/bin/bash

# 1. Run flutter tests with coverage
echo "🚀 Running flutter tests with coverage..."
flutter test --coverage

# 2. Check if genhtml is installed (part of lcov)
if ! command -v genhtml &> /dev/null
then
    echo "❌ genhtml could not be found. Please install 'lcov' to generate HTML reports."
    echo "💡 You can install it using Homebrew: brew install lcov"
    exit 1
fi

# 3. Generate HTML report from lcov.info
echo "📊 Generating HTML report..."
genhtml coverage/lcov.info -o coverage/html

# 4. Open the report in the browser (macOS)
echo "🌐 Opening coverage report..."
open coverage/html/index.html
