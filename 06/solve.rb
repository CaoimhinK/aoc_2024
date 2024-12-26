# frozen_string_literal: true

require 'matrix'

##
class Direction
  attr_reader :dir

  def initialize(dir)
    directions = { up: 0, right: 1, down: 2, left: 3 }
    @dir = if dir.is_a? Symbol
             directions[dir]
           elsif dir.is_a?(Integer) && dir >= 0 && dir < 4
             dir
           else
             raise 'Not a valid direction'
           end
  end

  def turn(num = 1)
    @dir = (@dir + num) % 4
  end

  def self.turned(dir, num)
    new_dir = dir.dup
    new_dir.turn(num)
    new_dir
  end

  def char
    ['^', '>', 'v', '<'][@dir]
  end

  def vec
    Vector.elements([
      [-1, 0],
      [0, 1],
      [1, 0],
      [0, -1]
    ][@dir])
  end

  def ==(other)
    @dir == other.dir
  end
end

##
class Patrol
  def initialize(input)
    @grid = parse_grid(input)
    @start_pos = find_guard_position
  end

  def parse_grid(input)
    input.split("\n").map { |row| row.split('') }
  end

  def find_guard_position
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |char, col_index|
        return Vector[row_index, col_index] if char == '^'
      end
    end
  end

  def look_ahead(pos, dir)
    vec = pos + dir.vec

    row = vec[0]
    col = vec[1]

    return nil unless in_bounds?(row, col)

    @grid[row][col]
  end

  def in_bounds?(row, col)
    row < @grid.size && row >= 0 && col < @grid[0].size && col >= 0
  end

  def walk(pos, dir)
    pos + dir.vec
  end

  def recursive_step(grid, pos, dir)
    char = look_ahead(pos, dir)

    if char == '#'
      recursive_step(grid, pos, Direction.turned(dir, 1)) + 0
    else
      grid[pos[0]][pos[1]] = dir.char

      return 1 if char.nil?

      unique_position = char == '.' ? 1 : 0

      recursive_step(grid, pos + dir.vec, dir) + unique_position
    end
  end

  def find_unique_positions
    recursive_step(@grid.dup, @start_pos, Direction.new(:up))
  end

  def render(marked)
    @grid.map.with_index do |row, row_index|
      row.map.with_index do |char, col_index|
        if marked.include?(Vector[row_index, col_index])
          "\e[32mX\e[0m"
        else
          char
        end
      end.join('')
    end.join("\n")
  end
end

patrol = Patrol.new(open('./input.txt').read)

puts "Part 1: #{patrol.find_unique_positions}"

# puts "Part 2: #{patrol.find_loops}"
