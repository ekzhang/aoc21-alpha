#!/bin/bash
set -e
wasm-as soln.wast -o soln.wasm
wasm-opt soln.wasm -o soln.opt.wasm -O3 --rse
node main.mjs
