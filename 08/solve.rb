class Vector
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_a
    [@x, @y]
  end

  def +(vec)
    Vector.new(@x + vec.x, @y + vec.y)
  end

  def -(vec)
    Vector.new(@x - vec.x, @y - vec.y)
  end

  def *(num)
    Vector.new(@x * num, @y * num)
  end

  def eql?(vec)
    @x == vec.x && @y == vec.y
  end

  def hash
    [@x, @y].hash
  end

  def to_s
    [@x, @y].to_s
  end

  def inspect
    [@x, @y].inspect
  end
end

def draw_grid(grid, antinodes = nil)
  if antinodes.nil?
    puts grid.map { |row| row.map { |char| (char != EMPTY_CHAR ? "\033[32m#{char}\033[0m" : char) }.join("") }.join("\n")
  else
    puts (grid.each_with_index.map do |row, row_i|
           (row.each_with_index.map do |char, col_i|
             antinodes.include?(Vector.new(row_i, col_i)) ? "\033[31m#\033[0m" : char
           end).join("")
         end).join("\n")
  end
end

EMPTY_CHAR = "."

input = File.readlines("./input.txt")

grid = input.map { |line| line.strip.split("") }

width = grid.size
height = grid[0].size

node_map = Hash.new { |h, key| h[key] = [] }

grid.each_with_index do |row, row_index|
  row.each_with_index do |char, column_index|
    node_map[char] << Vector.new(row_index, column_index) if char != EMPTY_CHAR
  end
end

antinodes = Set.new()

node_map.keys.each do |key|
  nodes = node_map[key]

  nodes.combination(2) do |a, b|
    diff = a - b

    antinodes << a + diff
    antinodes << b - diff
  end
end

antinodes.filter! { |node| node.x >= 0 && node.y >= 0 && node.x < width && node.y < height }

puts "Part 1: #{antinodes.size}"

# draw_grid(grid)
# draw_grid(grid, antinodes)

antinodes = Set.new()

node_map.keys.each do |key|
  nodes = node_map[key]

  combinations = nodes.combination(2).to_a

  if combinations.size == 0
    next
  else
    antinodes += nodes
  end

  combinations.each do |a, b|
    diff = a - b

    i = 1
    loop do
      antinode = a + (diff * i)

      if antinode.x >= 0 && antinode.x < width && antinode.y >= 0 && antinode.y < height
        antinodes << antinode
      else
        break
      end
      i += 1
    end

    i = 1
    loop do
      antinode = b - (diff * i)

      if antinode.x >= 0 && antinode.x < width && antinode.y >= 0 && antinode.y < height
        antinodes << antinode
      else
        break
      end
      i += 1
    end
  end
end

puts "Part 2: #{antinodes.size}"

# draw_grid(grid)
# draw_grid(grid, antinodes)
