# frozen_string_literal: true

##
class WireEvaluator
  attr_reader :outputs

  def initialize(input)
    @wires = {}
    @outputs = []

    wvs, wfs = input.split("\n\n")

    wire_values = parse_wire_values(wvs)
    wire_functions = parse_wire_functions(wfs)

    calc_wire_values(wire_values)
    calc_wire_functions(wire_functions)
  end

  def evaluate(name, wires)
    function, input1_name, input2_name = wires[name]
    if function == 'VAL'
      input1_name
    else
      input1 = evaluate(input1_name, wires)
      input2 = evaluate(input2_name, wires)
      case function
      when 'AND'
        input1 & input2
      when 'OR'
        input1 | input2
      when 'XOR'
        input1 ^ input2
      else
        raise 'Missing function!!'
      end
    end
  end

  def evaluate_all
    @outputs.sort.reverse.map do |output|
      evaluate(output, @wires)
    end.join('').to_i(2)
  end

  def parse_wire_values(wire_values)
    wire_values.split("\n").map { |row| /(?<name>.{3}): (?<value>1|0)/.match(row) }
  end

  def parse_wire_functions(wire_functions)
    wire_functions.split("\n").map do |row|
      /(?<input1>.{3}) (?<function>AND|OR|XOR) (?<input2>.{3}) -> (?<output>.{3})/.match(row)
    end
  end

  def calc_wire_values(wire_values)
    wire_values.each do |val|
      val => { name:, value: }
      @wires[name] = ['VAL', value.to_i]
      @outputs << name if name.start_with? 'z'
    end
  end

  def calc_wire_functions(wire_functions)
    wire_functions.each do |func|
      func => { input1:, input2:, function:, output: }
      @wires[output] = [function, input1, input2]
      @outputs << output if output.start_with? 'z'
    end
  end
end

input = open('./input.txt').read

evaluator = WireEvaluator.new(input)

puts evaluator.evaluate_all
