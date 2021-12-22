dedupe = (points) ->
  hsh = {}
  for _, v in ipairs points
    hsh[v.x * 1000000 + v.y] = v
  ret = {}
  for _, v in pairs hsh
    ret[#ret + 1] = v
  ret

reflx = (points, val) ->
  for _, v in pairs points
    if v.x > val
      v.x = 2 * val - v.x

refly = (points, val) ->
  for _, v in pairs points
    if v.y > val
      v.y = 2 * val - v.y

display = (points) ->
  xmax, ymax = 0, 0
  for _, v in pairs points
    if v.x > xmax
      xmax = v.x
    if v.y > ymax
      ymax = v.y
  grid = [ [' ' for i = 0, xmax] for j = 0, ymax]
  for _, v in pairs points
    grid[v.y + 1][v.x + 1] = '*'
  for y = 0, ymax
    for x = 0, xmax
      io.write grid[y + 1][x + 1]
    io.write "\n"

points = {}

while true do
  line = io.read!
  if line == ""
    break
  it = line\gmatch "%d+"
  a = tonumber it!
  b = tonumber it!
  points[#points + 1] = x: a, y: b

count = 0

while true do
  line = io.read!
  if line == nil
    break
  val = tonumber line\sub(14)
  if line\sub(12, 12) == "x"
    reflx points, val
    points = dedupe points
  else
    refly points, val
    points = dedupe points

  count += 1
  if count == 1
    print #points

display points
