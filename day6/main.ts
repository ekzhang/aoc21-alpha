/**
 * @file This solution is incredibly overkill, as it can handle up to ~10^5
 * days using some clever mathematical derivations, but the problem statement
 * only requires simulating up to 256 days.
 */

import * as fs from "fs/promises";

/**
 * Given that a lanternfish is born at time 0, how many lanternfish would
 * there be at time `n`?
 *
 * Time complexity is O(log n) bigint multiplications, using repeated squaring
 * on the polynomial ring given by R[x] / <x^9 - x^2 - 1>.
 *
 * If the problem asked for the solution modulo some large prime instead of the
 * actual integer output, then this would take logarithmic time.
 */
function simulate(n: bigint): bigint {
  let ans = 0n;
  for (let k = n; k > n - 7n; k--) {
    ans += compute_b(k);
  }
  return ans;
}

function compute_b(n: bigint): bigint {
  const p = ppow_mod([0n, 1n], n); // x^n
  return p[0] + p[7];
}

function ppow_mod(p: bigint[], k: bigint): bigint[] {
  if (k === 0n) return [1n];
  let ret = ppow_mod(pmul_mod(p, p), k / 2n);
  if (k % 2n) {
    ret = pmul_mod(ret, p);
  }
  return ret;
}

function pmul_mod(p: bigint[], q: bigint[]): bigint[] {
  const ret = Array<bigint>(p.length + q.length - 1).fill(0n);
  for (let i = 0; i < p.length; i++) {
    for (let j = 0; j < q.length; j++) {
      ret[i + j] += p[i] * q[j];
    }
  }
  while (ret.length > 9) {
    const k = ret.length - 1;
    ret[k - 7] += ret[k];
    ret[k - 9] += ret[k];
    ret.pop();
  }
  return ret;
}

function solve(days: bigint, inputs: bigint[]): bigint {
  let ans = 0n;
  for (const timer of inputs) {
    ans += simulate(days + (8n - timer));
  }
  return ans;
}

const file: string = await fs.readFile("input.txt", "utf-8");
const inputs = file
  .trim()
  .split(",")
  .map((x) => BigInt(x));

console.log(solve(80n, inputs).toString());
console.log(solve(256n, inputs).toString());
