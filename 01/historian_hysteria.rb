input = File.readlines("./input.txt")

data = input.reduce([[], []]) do |acc, line|
  left, right = line.split(" ")

  acc[0].push left.to_i
  acc[1].push right.to_i

  acc
end

data.each { |side| side.sort! }

left, right = data

if left.size != right.size
  puts "SIZES DON'T MATCH"
  exit 1
end

diff = left.zip(right).reduce(0) do |acc, items|
  litem, ritem = items

  acc + (litem - ritem).abs
end

puts "Diff is: #{diff}"

left, right = data


puts left.size

left.uniq!

sim_score = left.reduce(0) { |acc, item| acc + right.count(item) * item }

puts "SimScore is: #{sim_score}"