/** @file This is an AssemblyScript file. */

type Grid = i32[][];

export function main(input: string): u32 {
  const grid = parse(input.split("\n"));

  let t: u32 = 0;
  while (true) {
    t++;
    const move1 = step(grid, 1, 0, 1);
    const move2 = step(grid, 2, 1, 0);
    if (!move1 && !move2) {
      return t;
    }
  }
}

function parse(input: string[]): Grid {
  const n: i32 = input.length;
  const m: i32 = input[0].length;
  const grid: Grid = [];
  for (let i: i32 = 0; i < n; i++) {
    const row: i32[] = [];
    for (let j: i32 = 0; j < m; j++) {
      const c = input[i].at(j);
      if (c == ">") row.push(1);
      else if (c == "v") row.push(2);
      else row.push(0);
    }
    grid.push(row);
  }
  return grid;
}

function step(grid: Grid, ch: i32, dx: i32, dy: i32): u32 {
  const n: i32 = grid.length;
  const m: i32 = grid[0].length;
  const willMove: i32[][] = [];
  for (let i: i32 = 0; i < n; i++) {
    for (let j: i32 = 0; j < m; j++) {
      if (grid[i][j] == ch && grid[(i + dx) % n][(j + dy) % m] == 0) {
        willMove.push([i, j]);
      }
    }
  }

  for (let k: i32 = 0; k < willMove.length; k++) {
    const i = willMove[k][0];
    const j = willMove[k][1];
    grid[(i + dx) % n][(j + dy) % m] = ch;
    grid[i][j] = 0;
  }
  return willMove.length;
}
