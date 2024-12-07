require "set"

location_map = File.readlines("./input.txt").map { |line| line.strip.split("") }

GUARD_CHAR = "^"
OBSTACLE_CHAR = "#"
VISITED_CHAR = "X"

class Direction
  UP = 0
  RIGHT = 1
  DOWN = 2
  LEFT = 3
end

class Guard
  def initialize(location_map)
    @location_map = location_map
    @direction = Direction::UP
    @loop_count = 0
    @path = {}
    @loop_thresh = 0
    @step_count = 0

    @loop_positions = []

    @mep_positions = []

    location_map.each_with_index do |row, row_index|
      row.each_with_index do |cell_content, column_index|
        if (cell_content == GUARD_CHAR)
          @row = row_index
          @column = column_index
          @last_two_vertices = [[@row, @column]]

          @path[[@row, @column]] = { direction: @direction, index: @step_count }
          break
        end
      end

      if (!@position.nil?)
        break
      end
    end
  end

  def trace_rect
    case @direction
    when Direction::UP
      @loop_positions.any? do |row_index, column_index|
        _row, col = @last_two_vertices[0]
        @row == row_index && @column < col && (@column...col).all? { |c| @location_map[@row][c] != OBSTACLE_CHAR }
      end
    when Direction::RIGHT
      @loop_positions.any? do |row_index, column_index|
        row, _col = @last_two_vertices[0]
        @column == column_index && @row < row && (@row...row).all? { |r| @location_map[r][@column] != OBSTACLE_CHAR }
      end
    end
  end

  def loop_position?
    thing = get_neighbour((@direction + 3) % 4) == OBSTACLE_CHAR

    @loop_positions << [@row, @column] if thing

    thing
  end

  def get_neighbour(direction)
    case direction
    when Direction::UP
      @location_map[@row - 1][@column]
    when Direction::RIGHT
      @location_map[@row][@column + 1]
    when Direction::DOWN
      @location_map[@row + 1][@column]
    when Direction::LEFT
      @location_map[@row][@column - 1]
    end
  end

  def check_rect?
    mep = trace_rect

    @mep_positions << [@row, @column] if mep

    mep
  end

  def look_forward
    get_neighbour(@direction)
  end

  def _leave_trail
    @path[[@row, @column]] = { direction: @direction, index: @step_count }
  end

  def turn
    if @last_two_vertices.last != [@row, @column]
      @last_two_vertices.shift if @last_two_vertices.size == 2
      @last_two_vertices << [@row, @column]
    end
    @direction = (@direction + 1) % 4
  end

  def walk
    _leave_trail
    @step_count += 1

    case @direction
    when Direction::UP
      if @row == 0
        true
      else
        @row -= 1
        false
      end
    when Direction::RIGHT
      if @column == @location_map[0].size - 1
        true
      else
        @column += 1
        false
      end
    when Direction::DOWN
      if @row == @location_map.size - 1
        true
      else
        @row += 1
        false
      end
    when Direction::LEFT
      if @column == 0
        true
      else
        @column -= 1
        false
      end
    end
  end

  def make_patrol
    loop do
      @loop_count += 1 if check_rect?

      finished = loop do
        content = look_forward

        loop_position?

        if content == OBSTACLE_CHAR
          turn
        else
          break walk
        end
      end

      break if finished
    end
  end

  def count_positions
    @path.keys.size
  end

  def count_loops
    @loop_count
  end

  def draw_path(to = -1)
    @location_map.map.each_with_index do |row, row_index|
      row.map.each_with_index do |char, column_index|
        if @path.keys[0..to].include?([row_index, column_index])
          loop = @loop_positions.include?([row_index, column_index])
          mep = @mep_positions.include?([row_index, column_index])
          if (loop && mep)
            "\033[39;45mX\033[0m"
          elsif loop && !mep
            "\033[32;45mX\033[0m"
          elsif !loop && mep
            "\033[39mX\033[0m"
          else
            "\033[32mX\033[0m"
          end
        else
          if char == OBSTACLE_CHAR
            "\033[41m#{char}\033[0m"
          else
            char
          end
        end
      end.join("")
    end.join("\n")
  end
end

guard = Guard::new(location_map)

guard.make_patrol

puts "Part 1: #{guard.count_positions}"

puts "Part 2: #{guard.count_loops}" # ! doesn't work

puts guard.draw_path(400)
