# aoc21-alpha

[![](https://tokei.rs/b1/github/ekzhang/aoc21-alpha)](https://github.com/ekzhang/aoc21-alpha)

_Advent of Code 2021, but I solve the puzzles with 25 different programming languages **starting with each letter of the alphabet**._

The goal of this exercise was to learn some less-common programming languages that I've been curious about, in various paradigms, compilation modes, and historical contexts. Whenever there was a choice between multiple excellent languages for a given day's puzzle, I chose the one that I had the least familiarity with.

This was obviously intellectually challenging and pretty tough on environment setup, but hey, challenge is an essential part of exploration! ✨

## Learnings

See [`LEARNINGS.md`](./LEARNINGS.md) for some final observations about this experience.

## Schedule

To make things a little more tractable, I'm going through the alphabet in reverse order, since the hardest problems are at the end.

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
11. [OCaml](https://ocaml.org/) — [problem](https://adventofcode.com/2021/day/11), [solution](./day11)
12. [Nim](https://nim-lang.org/) — [problem](https://adventofcode.com/2021/day/12), [solution](./day12)
13. [MoonScript](https://moonscript.org/) — [problem](https://adventofcode.com/2021/day/13), [solution](./day13)
14. [Lisp (SBCL)](https://common-lisp.net/) — [problem](https://adventofcode.com/2021/day/14), [solution](./day14)
15. [Kotlin](https://kotlinlang.org/) — [problem](https://adventofcode.com/2021/day/15), [solution](./day15)
16. [Julia](https://julialang.org/) — [problem](https://adventofcode.com/2021/day/16), [solution](./day16)
17. [Idris](https://www.idris-lang.org/) — [problem](https://adventofcode.com/2021/day/17), [solution](./day17)
18. [Haskell](https://www.haskell.org/) — [problem](https://adventofcode.com/2021/day/18), [solution](./day18)
19. [Go](https://go.dev/) — [problem](https://adventofcode.com/2021/day/19), [solution](./day19)
20. [F#](https://fsharp.org/) — [problem](https://adventofcode.com/2021/day/20), [solution](./day20)
21. [Elixir](https://elixir-lang.org/) — [problem](https://adventofcode.com/2021/day/21), [solution](./day21)
22. [Dart](https://dart.dev/) — [problem](https://adventofcode.com/2021/day/22), [solution](./day22)
23. [Crystal](https://crystal-lang.org/) — [problem](https://adventofcode.com/2021/day/23), [solution](./day23)
24. [Boolector (BTOR)](https://boolector.github.io/) — [problem](https://adventofcode.com/2021/day/24), [solution](./day24)
25. [AssemblyScript](https://www.assemblyscript.org/) — [problem](https://adventofcode.com/2021/day/25), [solution](./day25)

## Development

First, create a `.env` file containing your session token from the Advent of Code website, so that the input data can be downloaded. For example:

```
SESSION=30b5d4e5790f02d4c32c71f59f10d5f2f6adfcf5b4c064c64a689ab02b4beb3e84bf74857e40cc9fe31088972fedeb64
```

Then, if you have [Python 3](https://python.org/) and [Just](https://github.com/casey/just) installed, as well as the language runtime for a given day's solution, you can load the input data and run the solution with:

```
just run <day1|day2|...>
```

Each day's solutions are located in their respective folder `dayN`. The source code reads from standard input, and it is executed using the script `run.sh`.

## Complete Run

If you have all of the required packages for the 25 languages installed, you can run all of the solutions sequentially with the command:

```
just run-all
```

This takes about a minute on my computer, since it needs to compile code in addition to running it.

## Runtime Environment

This is my runtime environment for each language on macOS Monterey v12.0.1, M1 / ARM64 processor, with Rosetta 2 and Xcode CLT. I only used languages that I could install on my own machine; these instructions aren't guaranteed to work on other operating systems or processor architectures.

- **Day 1:** Zig 0.10.0-dev.2028+ea913846c (`brew install zig --HEAD`).
- **Day 2:** Apple clang version 13.0.0, target arm64-apple-darwin21.1.0.
- **Day 3:** Binaryen version 102 (`brew install bianryen`).
- **Day 4:** V 0.2.4 b72a2de (`brew install vlang`).
- **Day 5:** Zsh 5.8 (x86_64-apple-darwin21.0).
- **Day 6:** TypeScript 4.5.4 (`npm install -g typescript`).
- **Day 7:** Scala 3.1.0 (`brew install coursier && cs install scala3 scala3-compiler`).
- **Day 8:** Ruby 3.0.3p157 for arm64-darwin21 (`brew install ruby`).
- **Day 9:** q version 2.0.20 (`brew install harelba/q/q`).
- **Day 10:** SWI-Prolog 8.4.1 for arm64-darwin (`brew install swi-prolog`).
- **Day 11:** OCaml 4.12.0 (`brew install opam && opam switch create 4.12.0`).
- **Day 12:** Nim 1.6.2 [MacOSX: arm64] (`brew install nim`).
- **Day 13:** MoonScript dev-1-b7efcd13 (`luarocks install moonscript --dev`), Lua 5.4.3, LuaRocks 3.8.0 (`brew install lua`).
- **Day 14:** Roswell 21.10.14.111 (`brew install roswell`), SBCL 2.1.11 (`ros install sbcl`).
- **Day 15:** Kotlin 1.6.10-release-923 (JRE 17.0.1+1) (`brew install kotlin`).
- **Day 16:** Julia 1.7.0 (`brew install --cask julia`).
- **Day 17:** Idris2 0.5.1, x86_64 version (`arch -x86_64 /usr/local/bin/brew install idris2`).
- **Day 18:** GHC 8.10.7, Cabal 3.6.2.0 (`brew install ghc cabal-install`).
- **Day 19:** Go 1.17.5, darwin/arm64 (`brew install go`).
- **Day 20:** .NET Core SDK 3.1.416 (`brew install --cask dotnet-sdk`).
- **Day 21:** Elixir 1.13.1, Erlang/OTP 24.2 (`brew install elixir`).
- **Day 22:** Flutter 2.8.1, Dart 2.15.1 (`brew install --cask flutter`).
- **Day 23:** Crystal 1.2.2 (`brew install crystal`).
- **Day 24:** Boolector 3.2.0 (`brew tap mht208/formal && brew install boolector`).
- **Day 25:** AssemblyScript 0.19.22.

Note that while exact version numbers are provided above, the code will likely work with newer versions of these languages as well. Also, assume a global dependency on Python 3.9+, Node v16+, and NPM v8+.
