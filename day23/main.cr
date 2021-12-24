# Generic priority queue sorted by minimum value, since this isn't in the standard library.
class PriorityQueue(T, U)
  def initialize
    @arr = Array({T, U}).new
  end

  def empty? : Bool
    @arr.size == 0
  end

  def <<(value : {T, U})
    push(value)
  end

  def push(value : {T, U})
    idx = @arr.size
    @arr << value
    while idx > 0
      parent = (idx - 1) // 2
      if @arr[parent][0] > value[0]
        @arr[idx] = @arr[parent]
        idx = parent
      else
        break
      end
    end
    @arr[idx] = value
    self
  end

  def pop : {T, U}
    if @arr.size == 0
      raise Exception.new "Cannot pop from an empty queue"
    elsif @arr.size == 1
      return @arr.pop
    end
    ret = @arr[0]
    last = @arr.pop
    idx = 0
    while true
      l, r = 2 * idx + 1, 2 * idx + 2
      if !(l < @arr.size && @arr[l][0] < last[0]) && !(r < @arr.size && @arr[r][0] < last[0])
        @arr[idx] = last
        break
      elsif r < @arr.size && @arr[r][0] <= @arr[l][0]
        # at the point before the condition, we know that l < @arr.size
        @arr[idx] = @arr[r]
        idx = r
      else
        @arr[idx] = @arr[l]
        idx = l
      end
    end
    ret
  end
end

module World
  alias State = Int8[23]

  GOAL = State[
    1i8, 1i8, 1i8, 1i8, 2i8, 2i8, 2i8, 2i8,
    3i8, 3i8, 3i8, 3i8, 4i8, 4i8, 4i8, 4i8,
    0i8, 0i8, 0i8, 0i8, 0i8, 0i8, 0i8,
  ]

  def self.parse(lines : Array(String)) : State
    chars = {'.' => 0i8, 'A' => 1i8, 'B' => 2i8, 'C' => 3i8, 'D' => 4i8}
    State[
      chars[lines[2][3]], chars[lines[3][3]], 1i8, 1i8,
      chars[lines[2][5]], chars[lines[3][5]], 2i8, 2i8,
      chars[lines[2][7]], chars[lines[3][7]], 3i8, 3i8,
      chars[lines[2][9]], chars[lines[3][9]], 4i8, 4i8,
      0i8, 0i8, 0i8, 0i8, 0i8, 0i8, 0i8,
    ]
  end

  def self.cost(kind : Int8) : Int32
    case kind
    when 1..4
      10 ** (kind - 1)
    else
      raise Exception.new "Invalid kind #{kind}"
    end
  end

  BETWEEN = {
    0 => {
      16 => {[17, 16], 3},
      17 => {[17], 2},
      18 => {[18], 2},
      19 => {[18, 19], 4},
      20 => {[18, 19, 20], 6},
      21 => {[18, 19, 20, 21], 8},
      22 => {[18, 19, 20, 21, 22], 9},
    },
    4 => {
      16 => {[18, 17, 16], 5},
      17 => {[18, 17], 4},
      18 => {[18], 2},
      19 => {[19], 2},
      20 => {[19, 20], 4},
      21 => {[19, 20, 21], 6},
      22 => {[19, 20, 21, 22], 7},
    },
    8 => {
      16 => {[19, 18, 17, 16], 7},
      17 => {[19, 18, 17], 6},
      18 => {[19, 18], 4},
      19 => {[19], 2},
      20 => {[20], 2},
      21 => {[20, 21], 4},
      22 => {[20, 21, 22], 5},
    },
    12 => {
      16 => {[20, 19, 18, 17, 16], 9},
      17 => {[20, 19, 18, 17], 8},
      18 => {[20, 19, 18], 6},
      19 => {[20, 19], 4},
      20 => {[20], 2},
      21 => {[21], 2},
      22 => {[21, 22], 3},
    },
  }

  # Returns a path `from`..`to` in 2D geometric space.
  def self.path(from : Int32, to : Int32) : {Array(Int32), Int32}
    if from >= 16
      ar, dist = path(to, from)
      return {ar.reverse[1..] << to, dist}
    end
    raise Exception.new "Path #{from}..#{to} should only move between hallway and room" if to < 8
    if from % 4 > 0
      top = from - from % 4
      ar, dist = path(top, to)
      {(from - 1).downto(top).to_a + ar, dist + from % 4}
    else
      BETWEEN[from][to]
    end
  end

  def self.visible(state : State, from : Int32, to : Int32) : Int32?
    cells, length = path(from, to)
    if cells.all? { |i| state[i] == 0 }
      cost(state[from]) * length
    else
      nil
    end
  end

  def self.move(state : State, from : Int32, to : Int32)
    ret = state.clone
    ret[to], ret[from] = state[from], state[to]
    ret
  end

  def self.neighbors(state : State) : Array({State, Int32})
    ret = Array({State, Int32}).new
    [0, 4, 8, 12].each do |roomPos|
      if state[roomPos] != 0
        x = roomPos
      elsif state[roomPos + 1] != 0
        x = roomPos + 1
      elsif state[roomPos + 2] != 0
        x = roomPos + 2
      elsif state[roomPos + 3] != 0
        x = roomPos + 3
      else
        next
      end
      if (x..(roomPos + 3)).any? { |idx| state[idx] != roomPos // 4 + 1 }
        (16..22).each do |y|
          visible(state, x, y).try do |cost|
            ret << {move(state, x, y), cost}
          end
        end
      end
    end
    (16..22).each do |x|
      kind = state[x]
      if kind != 0
        roomPos = 4 * (kind - 1)
        y = -1
        ((roomPos + 3).downto roomPos).each do |val|
          if state[val] == 0
            y = val
            break
          elsif state[val] != kind
            break
          end
        end
        if y != -1
          visible(state, x, y).try do |cost|
            ret << {move(state, x, y), cost}
          end
        end
      end
    end
    ret
  end

  # A simple implementation of Dijkstra's algorithm with a priority queue.
  def self.pathfind(state : State) : Int32
    dist = Hash(State, Int32).new
    vis = Set(State).new

    pq = PriorityQueue(Int32, State).new
    pq << {0, state}

    while !pq.empty?
      d, n = pq.pop
      if vis.includes? n
        next
      elsif n == GOAL
        return d
      end
      vis << n
      neighbors(n).each do |edge|
        v, cost = edge
        new_dist = d + cost
        if !dist.has_key?(v) || new_dist < dist[v]
          dist[v] = new_dist
          pq << {new_dist, v}
        end
      end
    end

    raise Exception.new "Could not find a path to the goal"
  end
end

# Part 1
start = World.parse STDIN.each_line.to_a
puts World.pathfind start

# Part 2
[0, 4, 8, 12].each do |x|
  start[x + 3] = start[x + 1]
end
# #D#C#B#A#
# #D#B#A#C#
start[1] = 4
start[2] = 4
start[5] = 3
start[6] = 2
start[9] = 2
start[10] = 1
start[13] = 1
start[14] = 3
puts World.pathfind start
