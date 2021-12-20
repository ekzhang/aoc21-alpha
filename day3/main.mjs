import * as fs from "fs/promises";

const wasmBuffer = await fs.readFile("soln.opt.wasm");
const wasmModule = await WebAssembly.instantiate(wasmBuffer);

const { soln, soln2, memory } = wasmModule.instance.exports;

const input = await fs.readFile("input.txt", "utf-8");
const lines = input.trim().split("\n");
const bitLength = lines[0].length;

const view = new Int32Array(memory.buffer, 0, lines.length);
for (let i = 0; i < lines.length; i++) {
  view[i] = parseInt(lines[i], 2);
}

console.log(soln(bitLength, lines.length));
console.log(soln2(bitLength, lines.length));
