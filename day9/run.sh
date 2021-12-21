#!/bin/bash
set -e
python3 preprocess.py
q -d , -H "$(cat part1.sql)" < cells.csv
q -d , -H "$(cat part2.sql)" < cells.csv | paste -s -d"*" - | bc
