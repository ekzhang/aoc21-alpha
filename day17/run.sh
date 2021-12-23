#!/bin/bash
set -e
idris2 -p contrib -o main main.idr
./build/exec/main
