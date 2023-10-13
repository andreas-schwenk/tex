#!/bin/bash
#   must edit CHANGELOG.md + change current version number everywhere
dart pub publish --dry-run
echo "... this was only a dry-run: must run again w/o --dry-run by hand!"
