input = File.readlines("./input.txt")

lines = input.map { |line| line.split(" ").map(&:to_i) }

safe_lines = lines.count do |line|

  prev_item = line[0]

  order = line[0] <=> line[1]

  if order == 0
    next false
  end

  line[1..].all? do |item|
    ordr = prev_item <=> item

    diff = (prev_item - item).abs

    prev_item = item

    if ordr == 0 || ordr != order
      next false
    end

    diff > 0 && diff < 4
  end
end

puts "Part 1", "Number of safe lines: #{safe_lines}"

puts

liens = input.map { |line| line.split(" ").map(&:to_i) }

def okay(out)
  true
end

safe_lines = liens.count do |line|

  first, second = line

  prev_item = first

  order = second <=> first

  strikes = 0

  line[1..].all? do |item|
    ordr = item <=> prev_item

    diff = (item - prev_item).abs

    out = !(ordr == 0 || ordr != order) && (diff > 0 && diff < 4)

    if out
      prev_item = item
      true
    else
      if strikes < 1
        strikes += 1
        true
      else
        false
      end
    end
  end
end

puts "Part 2", "Number of safe lines: #{safe_lines}"
