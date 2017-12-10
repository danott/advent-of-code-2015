require "minitest"
require "minitest/autorun"
require "pry"
require "awesome_print"

PUZZLE_INPUT = File.read("test/day_2_input.txt")

class TheTest < Minitest::Test
  def test_part_1
    assert_equal 58, wrapping_paper_needed("2x3x4")
    assert_equal 43, wrapping_paper_needed("1x1x10")
  end

  def test_part_2
    assert_equal 34, ribbon_needed("2x3x4")
    assert_equal 14, ribbon_needed("1x1x10")
  end

  def test_refactoring
    assert_equal 1588178, bulk_wrapping_paper_needed(PUZZLE_INPUT)
    assert_equal 3783758, bulk_ribbon_needed(PUZZLE_INPUT)
  end
end

def wrapping_paper_needed(dimensions)
  length, width, height = dimensions.split("x").map(&:to_i)
  small, medium, large = [length * width, length * height, width * height].sort
  (small * 3) + (medium * 2) + (large * 2)
end

def ribbon_needed(dimensions)
  small, medium, large = dimensions.split("x").map(&:to_i).sort
  (small * 2) + (medium * 2) + (small * medium * large)
end

def bulk_wrapping_paper_needed(manifest)
  manifest.lines.reduce(0) { |m, l| m + wrapping_paper_needed(l) }
end

def bulk_ribbon_needed(manifest)
  manifest.lines.reduce(0) { |m, l| m + ribbon_needed(l) }
end
