import sets
import strutils
import tables

var adj: Table[string, seq[string]]

while true:
  var line: string
  try:
    line = stdin.readLine
  except EOFError:
    break

  let toks = line.split("-")
  adj.mgetOrPut(toks[0], @[]).add(toks[1])
  adj.mgetOrPut(toks[1], @[]).add(toks[0])

proc isBig(cave: string): bool =
  cave[0].isUpperAscii

proc numPaths(cave: string, vis: var HashSet[string], extra: bool): int =
  if cave == "end":
    return 1

  var extra = extra
  var used_extra = false
  if vis.contains(cave):
    if cave == "start" or not extra:
      return 0
    extra = false
    used_extra = true

  var ret = 0
  if not cave.isBig and not used_extra:
    vis.incl(cave)
  for v in adj[cave]:
    ret += numPaths(v, vis, extra)
  if not cave.isBig and not used_extra:
    vis.excl(cave)
  return ret

proc solve(extra: bool): int =
  var vis: HashSet[string]
  numPaths("start", vis, extra)

echo solve(false)
echo solve(true)
