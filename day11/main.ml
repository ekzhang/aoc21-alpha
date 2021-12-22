open Fun
open Array

type grid = int array array

(* Step through one unit of time, returning the total number of flashes. *)
let step (grid:grid) : int =
  let n = length grid in
  let m = length grid.(0) in
  let in_range (row, col) =
    0 <= row && row < n && 0 <= col && col < m in
  let neighbors (row, col) =
    List.filter in_range
      [ row - 1, col - 1; row - 1, col; row - 1, col + 1
      ; row, col - 1; row, col + 1
      ; row + 1, col - 1; row + 1, col; row + 1, col + 1] in
  let all_cells =
    List.flatten @@
    List.map (fun i -> List.map (fun j -> i, j) (List.init m id)) (List.init n id) in
  ignore @@ List.map
    (fun (x, y) ->
       grid.(x).(y) <- grid.(x).(y) + 1)
    all_cells;
  let rec visit (x, y) =
    if grid.(x).(y) > 9 then begin
      grid.(x).(y) <- 0;
      List.fold_left
        (fun sum (x2, y2) ->
           if grid.(x2).(y2) > 0 then begin
             grid.(x2).(y2) <- grid.(x2).(y2) + 1;
             sum + visit (x2, y2)
           end else
             sum)
        1 (neighbors (x, y))
    end else
      0
  in
  List.fold_left (fun sum cell -> sum + (visit cell)) 0 all_cells

let read_input () : grid =
  let grid = ref [] in
  try
    while true; do
      let line = read_line () in
      let row =
        init
          (String.length line)
          (fun i -> Char.code (String.get line i) - Char.code '0') in
      grid := row :: !grid
    done; of_list !grid
  with End_of_file ->
    of_list (List.rev !grid)

let main () =
  let grid = read_input () in
  let flashes = List.fold_left (fun sum _ -> sum + step grid) 0 (List.init 100 id) in
  print_int flashes;
  print_newline ();
  let time = ref 100 in
  let flashes = ref 0 in
  while !flashes <> (length grid) * (length grid.(0)); do
    time := !time + 1;
    flashes := step grid
  done;
  print_int !time;
  print_newline ()

;;

main ()
