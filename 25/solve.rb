# frozen_string_literal: true

class LockTester
  def initialize(input)
    keys_and_locks = parse_input(input)
    @keys = keys_and_locks[:keys]
    @locks = keys_and_locks[:locks]
  end

  def parse_block(rows)
    rows.each_with_object(Array.new(rows[0].size, 0)) do |row, ary|
      row.each_char.each_with_index do |char, index|
        ary[index] += char == '#' ? 1 : 0
      end
    end
  end

  def parse_input(input)
    input.split("\n\n").each_with_object({ keys: [], locks: [] }) do |block, obj|
      rows = block.split("\n")
      type = rows[0][0] == '#' ? :keys : :locks
      key_or_lock = parse_block(rows)
      obj[type] << key_or_lock
    end
  end

  def check_pair(key, lock)
    key.size.times.all? do |i|
      key[i] + lock[i] <= 7
    end
  end

  def check_pairs
    @keys.reduce(0) do |sum, key|
      sum + @locks.count do |lock|
        check_pair(key, lock)
      end
    end
  end
end

tester = LockTester.new(open('./input.txt').read)

puts "Part 1: #{tester.check_pairs}"
