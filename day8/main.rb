require 'set'

ans = 0
ans2 = 0

STDIN.read.split("\n").each do |line|
  patterns, outputs = line.split(' | ')
  ans += outputs.split.filter {|s| [2, 3, 4, 7].include? s.length }.count

  for p in patterns.split
    if p.length == 2
      c1 = p.chars.to_set
    elsif p.length == 3
      c7 = p.chars.to_set
    elsif p.length == 4
      c4 = p.chars.to_set
    elsif p.length == 7
      c8 = p.chars.to_set
    end
  end

  parse = lambda { |s|
    x = s.chars.to_set
    if x == c1
      1
    elsif x == c7
      7
    elsif x == c4
      4
    elsif x == c8
      8
    elsif x.length == 6
      # 0, 6, 9
      if c1.subset? x
        # 0, 9
        if c4.subset? x
          9
        else
          0
        end
      else
        6
      end
    elsif x.length == 5
      # 2, 3, 5
      if c7.subset? x
        3
      else
        # 2, 5
        if x.intersection(c4).length == 3
          5
        else
          2
        end
      end
    else
      raise Exception.new "invalid chars: #{s}"
    end
  }

  output = outputs.split.map {|s| parse.call(s).to_s}.join.to_i
  ans2 += output
end

puts ans
puts ans2
