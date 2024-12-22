# frozen_string_literal: true

require 'matrix'

def machine(button_a, button_b, prize)
  det = Matrix[button_a, button_b].determinant
  det_x = Matrix[prize, button_b].determinant
  det_y = Matrix[button_a, prize].determinant

  vec_x = Vector[*button_a]
  vec_y = Vector[*button_b]

  solution = vec_x * (det_x / det) + vec_y * (det_y / det)

  if solution == Vector[*prize]
    [det_x / det, det_y / det]
  else
    false
  end
end

input = open('./input.txt').read.chomp

regex_string = <<~REGEX.chomp
  Button A: X\\+(\\d+), Y\\+(\\d+)
  Button B: X\\+(\\d+), Y\\+(\\d+)
  Prize: X=(\\d+), Y=(\\d+)
REGEX

regex = Regexp.new(regex_string)

machines = input.split("\n\n").map do |block|
  a, b, c, d, e, f = regex.match(block).captures.map(&:to_i)
  [[a, b], [c, d], [e, f]]
end

def machine_tokens(machines, add_prize = 0)
  machines.map do |button_a, button_b, prize|
    the_prize = prize.map { |a| a + add_prize }
    mac = machine(button_a, button_b, the_prize)

    if mac
      a, b = mac
      a * 3 + b
    end
  end.compact.sum
end

puts "Part 1: #{machine_tokens(machines)}"
puts "Part 2: #{machine_tokens(machines, 10_000_000_000_000)}"
