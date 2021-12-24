defmodule Part1 do
  def rem1(x, m) do
    rem(x + m - 1, m) + 1
  end

  def roll(turn) do
    rem1(3 * turn + 1, 100) +
      rem1(3 * turn + 2, 100) +
      rem1(3 * turn + 3, 100)
  end

  def simulate(pos1, pos2, turn \\ 0, score1 \\ 0, score2 \\ 0) do
    cond do
      score1 >= 1000 ->
        score2 * 3 * turn

      score2 >= 1000 ->
        score1 * 3 * turn

      rem(turn, 2) == 0 ->
        new = rem1(pos1 + roll(turn), 10)
        simulate(new, pos2, turn + 1, score1 + new, score2)

      rem(turn, 2) == 1 ->
        new = rem1(pos2 + roll(turn), 10)
        simulate(pos1, new, turn + 1, score1, score2 + new)
    end
  end
end

read_pos = fn ->
  IO.read(:stdio, :line)
  |> String.split(" ")
  |> List.last()
  |> String.trim()
  |> String.to_integer()
end

pos1 = read_pos.()
pos2 = read_pos.()

IO.puts(Part1.simulate(pos1, pos2))

defmodule Part2 do
  use Agent

  def rem1(x, m) do
    rem(x + m - 1, m) + 1
  end

  def sum_pairs([]) do
    {0, 0}
  end

  def sum_pairs([{a, b} | t]) do
    {a1, b1} = sum_pairs(t)
    {a + a1, b + b1}
  end

  def start do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def simulate(pos1, pos2, turn \\ 0, score1 \\ 0, score2 \\ 0) do
    cond do
      score1 >= 21 ->
        {1, 0}

      score2 >= 21 ->
        {0, 1}

      true ->
        args = {pos1, pos2, turn, score1, score2}
        cached_value = Agent.get(__MODULE__, &Map.get(&1, args))

        if cached_value do
          cached_value
        else
          moves = [{3, 1}, {4, 3}, {5, 6}, {6, 7}, {7, 6}, {8, 3}, {9, 1}]

          outcomes =
            if turn == 0 do
              for {roll, count} <- moves,
                  do:
                    (with new <- rem1(pos1 + roll, 10),
                          {a, b} <- simulate(new, pos2, 1 - turn, score1 + new, score2) do
                       {count * a, count * b}
                     end)
            else
              for {roll, count} <- moves,
                  do:
                    (with new <- rem1(pos2 + roll, 10),
                          {a, b} <- simulate(pos1, new, 1 - turn, score1, score2 + new) do
                       {count * a, count * b}
                     end)
            end

          v = sum_pairs(outcomes)
          Agent.update(__MODULE__, &Map.put(&1, args, v))
          v
        end
    end
  end
end

{:ok, _} = Part2.start()
{wins1, wins2} = Part2.simulate(pos1, pos2)
IO.puts(max(wins1, wins2))
