require_relative "utils"

grid = File.readlines("./input.txt").map { |line| line.strip.split("") }

target = "XMAS"

count = 0

def check(char, target, target_pointer, count)
  if char == target[target_pointer]
    if target_pointer == target.size - 1
      [count + 1, 0]
    else
      [count, target_pointer + 1]
    end
  else
    if (char == target[0])
      [count, 1]
    else
      [count, 0]
    end
  end
end

each_row(grid) do |row|
  target_pointer = 0
  row.each do |char|
    count, target_pointer = check(char, target, target_pointer, count)
  end
end

each_row(grid) do |row|
  target_pointer = 0
  row.reverse.each do |char|
    count, target_pointer = check(char, target, target_pointer, count)
  end
end

each_column(grid) do |column|
  target_pointer = 0
  column.each do |char|
    count, target_pointer = check(char, target, target_pointer, count)
  end
end

each_column(grid) do |column|
  target_pointer = 0
  column.reverse.each do |char|
    count, target_pointer = check(char, target, target_pointer, count)
  end
end

each_diagonal(grid) do |diagonal|
  target_pointer = 0
  diagonal.each do |char|
    count, target_pointer = check(char, target, target_pointer, count)
  end
end

each_diagonal(grid) do |diagonal|
  target_pointer = 0
  diagonal.reverse.each do |char|
    count, target_pointer = check(char, target, target_pointer, count)
  end
end

puts "Part 1: #{count}"

def x_mas?(char, grid, row_index, col_index)
  if char == "A"
    top_left = grid[row_index - 1][col_index - 1]
    top_right = grid[row_index - 1][col_index + 1]
    bottom_left = grid[row_index + 1][col_index - 1]
    bottom_right = grid[row_index + 1][col_index + 1]

    (
      (top_left == "M" && bottom_right == "S") ||
      (top_left == "S" && bottom_right == "M")
    ) &&
      (
        (bottom_left == "M" && top_right == "S") ||
        (bottom_left == "S" && top_right == "M")
      )
  end
end

count = 0

each_row(grid).with_index do |row, row_index|
  if row_index == 0 || row_index == grid.size - 1
    next
  end

  row.each_with_index do |char, col_index|
    if col_index == 0 || col_index == grid[0].size - 1
      next
    end

    if x_mas?(char, grid, row_index, col_index)
      count += 1
    end
  end
end

puts "Part 2: #{count}"
