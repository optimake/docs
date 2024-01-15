#!/bin/bash

python3 -m mkdocs build
echo "Update Website Code!"   
cp -rf site/* ../docs/
