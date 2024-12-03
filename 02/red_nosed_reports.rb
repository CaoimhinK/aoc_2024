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

puts "Number of safe lines: #{safe_lines}"

# input = (
# <<LINES
# 7 6 4 2 1
# 1 2 7 8 9
# 9 7 6 2 1
# 1 3 2 4 5
# 8 6 4 4 1
# 1 3 6 7 9
# 9 1 2 3 4
# LINES
# ).split("\n")

liens = input.map { |line| line.split(" ").map(&:to_i) }

def okay(out)
  true
end

safe_lines = liens.count do |line|

  first, second = line

  prev_item = first

  order = second <=> first

  strikes = 0

  uff = line[1..].all? do |item|
    ordr = item <=> prev_item

    diff = (item - prev_item).abs

    out = !(ordr == 0 || ordr != order) && (diff > 0 && diff < 4)

    if out
      puts "Item <#{item}>: #{ordr}, #{diff}, #{out}, #{strikes} <<1>>" if okay(out)
      prev_item = item
      true
    else
      if strikes < 1
        puts "Item <#{item}>: #{ordr}, #{diff}, #{out}, #{strikes} <<2>>" if okay(out)
        strikes += 1
        true
      else
        puts "Item <#{item}>: #{ordr}, #{diff}, #{out}, #{strikes} <<3>>" if okay(out)
        false
      end
    end
  end

  puts "IS DIS: #{uff}" if okay(uff)

  uff
end

puts "Number of safe lines: #{safe_lines}"
