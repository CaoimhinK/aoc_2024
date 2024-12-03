input = File.read("./input.txt")

findMul = /mul\((\d{1,3}),(\d{1,3})\)/

results_sum = input.scan(findMul).map { |a, b| a.to_i * b.to_i }.sum

puts "Part 1", "Multiplication result is: #{results_sum}"
puts

findFunc = /(?<func>mul|do|don't)\(((?<one>\d{1,3}),(?<two>\d{1,3}))?\)/

enabled = true

results = input.scan(findFunc).map do |func, one, two|
  case func
  when "mul"
    if enabled
      one.to_i * two.to_i
    else
      0
    end
  when "do"
    enabled = true
    0
  when "don't"
    enabled = false
    0
  end
end

results_sum = results.sum

puts "Part 2", "Multiplication result is: #{results_sum}"