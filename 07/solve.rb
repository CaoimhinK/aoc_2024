input = File.readlines("./input.txt").map do |line|
  result, operands = line.split(": ")
  [result, operands.strip.split(" ")]
end

def evaluate_operator(operand1, operator, operand2)
  case operator
  when "+"
    (operand1.to_i + operand2.to_i).to_s
  when "*"
    (operand1.to_i * operand2.to_i).to_s
  when "||"
    operand1 + operand2
  end
end

def evaluate_operands(result, operands, operators)
  permutations = operators.repeated_permutation(operands.size - 1)
  permutations.each do |perm|
    equation_result = operands[1..].each_with_index.reduce(operands[0]) do |acc, operand_with_index|
      operand, index = operand_with_index
      evaluate_operator(acc, perm[index], operand)
    end

    if (equation_result.to_i == result.to_i)
      return result.to_i
    end
  end
  return 0
end

operators = ["*", "+"]

calibration_result = 0

input.each do |result, operands|
  calibration_result += evaluate_operands(result, operands, operators)
end

puts "Part 1: #{calibration_result}"

operators = ["+", "*", "||"]

calibration_result = 0

input.each do |result, operands|
  calibration_result += evaluate_operands(result, operands, operators)
end

puts "Part 2: #{calibration_result}"
