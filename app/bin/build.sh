#!/bin/sh

## Buid script for start application

pub install

echo "Run tests..."
dart test/test.dart

echo "Build Web UI app..."
dart build.dart

echo "Compile to js..."
dart2js --checked --minify --out=web/out/index.html_bootstrap.dart.js web/out/index.html_bootstrap.dart
