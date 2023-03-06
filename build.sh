#!/bin/bash

# build lib/src/svg.dart
cd font
./run.sh
cd ..
dart format lib/src/svg.dart

# build lib/src/tab.dart
python3 meta/run.py
if [ $? -ne 0 ]
then
    exit -1
fi
dart format lib/src/tab.dart

# build website
cd docs
./build.sh
cd ..
