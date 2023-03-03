#!/bin/bash

# build lib/src/svg.dart
cd font
./run.sh
cd ..

# build lib/src/tab.dart
python3 meta/run.py
if [ $? -ne 0 ]
then
    exit -1
fi

# build website
cd docs
./build.sh
cd ..
