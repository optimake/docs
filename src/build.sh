#!/bin/bash
rm -rf site
echo "Build Website!"
python3 -m mkdocs build

echo "Clean Website Code!"
rm -rf ../docs/*
mkdir -p ../docs
echo "Update Website Code!"   
cp -rf site/* ../docs/
