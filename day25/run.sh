#!/bin/bash
set -e
npm install 2>&1 > /dev/null
npm run asbuild > /dev/null
node .
