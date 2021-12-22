# aoc21-alpha

_Advent of Code 2021 solutions, but every day, I use a new programming language **starting with a different letter of the alphabet**._

The goal of this exercise is to think about some new programming languages that I've been curious about for a while now. Whenever there's a choice between multiple excellent languages within a category, I pick the one that I have the least familiarity with.

All of this will be challenging, as well as a nightmare for environment setup, but hey, challenge is an essential part of exploration! ✨

## Schedule (Tentative)

To make things a little more tractable, I'll be going through the alphabet in reverse order, since the hardest problems are at the end.

1. [Zig](https://ziglang.org/) — [problem](https://adventofcode.com/2021/day/1), [solution](./day1)
2. [x86 Assembly](https://en.wikipedia.org/wiki/X86_assembly_language) — [problem](https://adventofcode.com/2021/day/2), [solution](./day2)
3. [WebAssembly](https://webassembly.org/) — [problem](https://adventofcode.com/2021/day/3), [solution](./day3)
4. [V](https://vlang.io/) — [problem](https://adventofcode.com/2021/day/4), [solution](./day4)
5. [Unix Shell (Zsh)](https://www.zsh.org/) — [problem](https://adventofcode.com/2021/day/5), [solution](./day5)
6. [TypeScript](https://www.typescriptlang.org/) — [problem](https://adventofcode.com/2021/day/6), [solution](./day6)
7. [Scala](https://www.scala-lang.org/) — [problem](https://adventofcode.com/2021/day/7), [solution](./day7)
8. [Ruby](https://www.ruby-lang.org/en/) — [problem](https://adventofcode.com/2021/day/8), [solution](./day8)
9. [Q (SQL)](https://github.com/harelba/q) — [problem](https://adventofcode.com/2021/day/9), [solution](./day9)
10. [Prolog](https://www.swi-prolog.org/) — [problem](https://adventofcode.com/2021/day/10), [solution](./day10)
11. [Odin](https://odin-lang.org/)
12. [Nim](https://nim-lang.org/)
13. [Mun](https://mun-lang.org/)
14. [Lisp (SBCL)](https://common-lisp.net/)
15. [Kotlin](https://kotlinlang.org/)
16. [Julia](https://julialang.org/)
17. [Idris](https://www.idris-lang.org/)
18. [Haskell](https://www.haskell.org/)
19. [Go](https://go.dev/)
20. [F#](https://fsharp.org/)
21. [Elixir](https://elixir-lang.org/)
22. [Dart](https://dart.dev/)
23. [Crystal](https://crystal-lang.org/)
24. [Bosque](https://github.com/Microsoft/BosqueLanguage)
25. [AssemblyScript](https://www.assemblyscript.org/)

## Development

First, create a `.env` file containing your session token from the Advent of Code website, so that the input data can be downloaded. For example:

```
SESSION=30b5d4e5790f02d4c32c71f59f10d5f2f6adfcf5b4c064c64a689ab02b4beb3e84bf74857e40cc9fe31088972fedeb64
```

Then, if you have [Python 3](https://python.org/) and [Just](https://github.com/casey/just) installed, as well as additional specific language runtimes, you can load the data and run the solution for a given day with:

```
just run <day1|day2|...>
```

Each day's solutions are located in their respective folder `dayN`. The source code reads from standard input, and it is executed using the script `run.sh`.
