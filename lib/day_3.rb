require "minitest"
require "minitest/autorun"
require "pry"
require "awesome_print"

PUZZLE_INPUT = File.read("test/day_3_input.txt")

class TheTest < Minitest::Test
  def test_part_1
    assert_equal 2, total_houses(">")
    assert_equal 4, total_houses("^>v<")
    assert_equal 2, total_houses("^v^v^v^v^v")
  end

  def test_part_2
    assert_equal 3, robo_santa_total_houses("^v")
    assert_equal 3, robo_santa_total_houses("^>v<")
    assert_equal 11, robo_santa_total_houses("^v^v^v^v^v")
  end

  def test_refactoring
    assert_equal 2572, total_houses(PUZZLE_INPUT)
    assert_equal 2631, robo_santa_total_houses(PUZZLE_INPUT)
  end
end

def total_houses(instructions)
  SleighRide.new(instructions: instructions).ride.total_houses
end

def robo_santa_total_houses(instructions)
  santa_instructions = []
  robo_santa_instructions = []

  instructions.chars.each_with_index do |instruction, index|
    if index.even?
      santa_instructions << instruction
    else
      robo_santa_instructions << instruction
    end
  end

  santa = SleighRide.new(instructions: santa_instructions.join).ride
  robo_santa = SleighRide.new(instructions: robo_santa_instructions.join).ride

  (santa.every_location + robo_santa.every_location).uniq.count
end

class SleighRide
  attr_accessor :x, :y, :instructions, :history

  def initialize(x: 0, y: 0, instructions:, history: [])
    @x = x
    @y = y
    @instructions = instructions.chars
    @history = history
  end

  def ride
    self.next until done?
    self
  end

  def done?
    instructions.empty?
  end

  def next
    history << to_history
    case instructions.shift
    when "^"
      self.y += 1
    when ">"
      self.x += 1
    when "<"
      self.x -= 1
    when "v"
      self.y -= 1
    end
    self
  end

  def total_houses
    every_location.uniq.count
  end

  def every_location
    history + [to_history]
  end

  private

  def to_history
    [x, y]
  end
end
