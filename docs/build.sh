#!/bin/bash
dart compile js index.dart -O4 -o index.min.js
python3 build.py
