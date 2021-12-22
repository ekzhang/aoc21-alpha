#!/bin/bash
set -e
nim c -r -d:release --hints:off main.nim
