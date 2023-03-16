#!/bin/bash
dart compile js index.dart -O4 -o index.min.js
dart compile js compare.dart -O4 -o compare.min.js
python3 build.py
