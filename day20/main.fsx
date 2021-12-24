#r "nuget: FSharp.Collections.ParallelSeq, Version=1.2.0"

open System
open FSharp.Collections.ParallelSeq

let rules = Console.ReadLine()
Console.ReadLine()

// Sanity checks for valid input
if String.length rules <> 512 then
  failwith "Rules length is invalid, should be 512"
if rules.[0] = '#' && rules.[511] = '#' then
  failwith "Cannot simulate this board, will have infinite population"

let grid =
  fun _ -> Console.ReadLine()
  |> Seq.initInfinite // (1)
  |> Seq.takeWhile ((<>) null)

/// Set containing all the cells in the input, as ordered pairs of coordinates.
let cells = Set(query {
  for i, row in grid |> Seq.mapi (fun i row -> (i, row)) do
    for j, char in row |> Seq.mapi (fun i char -> (i, char)) do
      if char = '#' then
        select (i, j)
})

let board =
  cells,
  1 + (cells |> Seq.map (fun (i, _) -> i) |> Seq.max),
  1 + (cells |> Seq.map (fun (_, j) -> j) |> Seq.max)

/// Check if the cell at the given coordinate is alive in the next step.
let step1 gen (rules : string) (cells, n, m) (i, j) =
  let mutable value = 0
  for a in [i - 1 .. i + 1] do
    for b in [j - 1 .. j + 1] do
      let on =
        if Set.contains (a, b) cells
          || (rules.[0] = '#' && gen % 2 = 1 && (a < 0 || a >= n || b < 0 || b >= m))
          then 1 else 0
      value <- 2 * value + on
  rules.[value] = '#'

let step gen (cells, n, m) =
  (Seq.allPairs [-1 .. n + 1] [-1 .. m + 1]
  |> PSeq.filter (step1 gen rules (cells, n, m))
  |> Seq.map (fun (i, j) -> (i + 1, j + 1))
  |> Set), n + 2, m + 2

let rec stepN n cells =
  match n with
  | 0 -> cells
  | _ -> cells |> stepN (n - 1) |> step (n - 1)

let solve board n =
  board
  |> stepN n
  |> (fun (cells, _, _) -> Set.count cells)

printfn "%A" <| solve board 2
printfn "%A" <| solve board 50

