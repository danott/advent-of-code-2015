require "minitest"
require "minitest/autorun"
require "pry"
require "awesome_print"

PUZZLE_INPUT = File.read("lib/day_6_input.txt")

class TheTest < Minitest::Test
  def instructions
    Instruction.parse_manual(PUZZLE_INPUT)
  end

  def test_part_1
    assert_equal 377891, LightGrid.new(Light).call(instructions).count
  end

  def test_part_2
    assert_equal 14110788, LightGrid.new(FancyLight).call(instructions).count
  end
end

class Instruction
  def self.parse_manual(manual)
    manual.lines.map { |l| parse_line(l) }
  end

  def self.parse_line(line)
    parts = line.split
    action = parts.shift until %w(toggle on off).include?(action)
    from = parts.first.split(",").map(&:to_i)
    to = parts.last.split(",").map(&:to_i)
    new(action: action, from: from, to: to)
  end

  attr_reader :action, :from, :to

  def initialize(action:, from:, to:)
    @action = action
    @from = from
    @to = to
  end

  def call(grid)
    from.first.upto(to.first) do |x|
      from.last.upto(to.last) do |y|
        grid[x][y].public_send(action)
      end
    end
  end
end

class LightGrid
  attr_reader :grid

  def initialize(light)
    @grid = 0.upto(999).map do
      0.upto(999).map do
        light.new
      end
    end
  end

  def call(instructions)
    self.next(instructions.shift) until instructions.empty?
    self
  end

  def next(instruction)
    instruction.call(grid)
    self
  end

  def count
    grid.flatten.map(&:brightness).reduce(&:+)
  end
end

class Light
  attr_accessor :lit

  def initialize
    off
  end

  def on
    self.lit = true
    self
  end

  def off
    self.lit = false
    self
  end

  def toggle
    self.lit = !lit
    self
  end

  def brightness
    lit ? 1 : 0
  end
end

class FancyLight
  attr_accessor :brightness

  def initialize
    self.brightness = 0
  end

  def on
    self.brightness += 1
    self
  end

  def off
    self.brightness -= 1 unless brightness.zero?
    self
  end

  def toggle
    self.brightness += 2
    self
  end
end
