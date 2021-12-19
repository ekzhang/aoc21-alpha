#!/bin/bash
arch -x86_64 clang -masm=att -o main main.c soln.S
./main
