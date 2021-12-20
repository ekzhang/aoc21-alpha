#!/bin/bash
set -e
tsc
mv build/main.js build/main.mjs
node build/main.mjs
