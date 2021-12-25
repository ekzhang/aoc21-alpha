import fs from "fs/promises";
import path from "path";
import loader from "@assemblyscript/loader";

const wasmModule = await loader.instantiateStreaming(
  fs.readFile(path.resolve("build/optimized.wasm"))
);

const buffer = await fs.readFile("input.txt");
const input = buffer.toString().trim();

const { main, __newString } = wasmModule.exports;
const inputPtr = __newString(input);
const result = main(inputPtr);
console.log(result.toString());
