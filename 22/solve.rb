# frozen_string_literal: true

input = open('./input.txt').read

def mix(secret_number, result)
  secret_number ^ result
end

def prune(secret_number)
  secret_number % 16_777_216
end

def next_secret_number(secret_number)
  secret_number = prune(mix(secret_number, secret_number * 64))
  secret_number = prune(mix(secret_number, secret_number / 32))
  prune(mix(secret_number, secret_number * 2048))
end

secret_sum = 0
input.split("\n").each do |secret_number_string|
  secret_number = secret_number_string.to_i

  2000.times do
    secret_number = next_secret_number(secret_number)
  end

  secret_sum += secret_number
end

puts "Part 1: #{secret_sum}"

def slide_array(ary, new_number, max_size)
  ary = ary.dup
  ary.shift unless ary.size < max_size
  ary << new_number
  ary
end

sequence_values = {}

lines = input.split("\n")

lines.each_with_index do |secret_number_string, index|
  secret_number = secret_number_string.to_i

  price = secret_number % 10

  change_sequence = []

  2000.times do |i|
    secret_number = next_secret_number(secret_number)
    old_price = price
    price = secret_number % 10
    change = price - old_price

    change_sequence = slide_array(change_sequence, change, 4)

    sequence_value = sequence_values[change_sequence]

    if change_sequence.size == 4
      if sequence_value.nil?
        sequence_values[change_sequence] = [index, price]
      else
        last_i, value = sequence_value
        sequence_values[change_sequence] = [index, value + price] if last_i != index
      end
    end

    times_perc = (100 * i / 2000.0).round
    number_perc = ((100.0 * index) / lines.size).round

    print "\e[2K\rtimes: #{times_perc}%, numbers: #{number_perc}%"
  end
end

puts

max_sequence = sequence_values.keys.max { |a, b| sequence_values[a][1] <=> sequence_values[b][1] }

puts "Part 2: #{max_sequence}, Bananas: #{sequence_values[max_sequence][1]}"
