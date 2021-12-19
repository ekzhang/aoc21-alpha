import * as fs from "fs/promises";

const wasmBuffer = await fs.readFile("soln.opt.wasm");
const wasmModule = await WebAssembly.instantiate(wasmBuffer);

const add = wasmModule.instance.exports.add;
const sum = add(5, 6);
console.log(sum); // Outputs: 11
