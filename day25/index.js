import fs from "fs/promises";
import path from "path";
import loader from "@assemblyscript/loader";

const wasmModule = await loader.instantiateStreaming(
  fs.readFile(path.resolve("build/optimized.wasm")),
  {} // imports
);

const buffer = await fs.readFile("input.txt");
const input = buffer.toString().trim();

const { main, __newString, __getString } = wasmModule.exports;
const inputPtr = __newString(input);
const outputPtr = main(inputPtr);
console.log(__getString(outputPtr));
