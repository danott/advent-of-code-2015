require "minitest"
require "minitest/autorun"
require "pry"
require "awesome_print"

PUZZLE_INPUT = File.read("./test/day_5_input.txt")

class TheTest < Minitest::Test
  def test_part_1
    assert nice?("ugknbfddgicrmopn")
    assert nice?("aaa")
    refute nice?("jchzalrnumimnmhp")
    refute nice?("haegwjzuvuyypxyu")
    refute nice?("dvszwmarrgswjxmb")
  end

  def test_part_2
    assert nice?("qjhvhtzxzqqjkmpb", sorter: AdvancedSorter)
    assert nice?("xxyxx", sorter: AdvancedSorter)
    refute nice?("uurcxstgmygtbstg", sorter: AdvancedSorter)
    refute nice?("ieodomkazucvgmuy", sorter: AdvancedSorter)
  end

  def test_refactoring
    assert_equal 238, size_of_nice_list(PUZZLE_INPUT, sorter: Sorter)
    assert_equal 69, size_of_nice_list(PUZZLE_INPUT, sorter: AdvancedSorter)
  end
end

def nice?(string, sorter: Sorter)
  sorter.new(string).nice?
end

class Sorter
  attr_reader :string

  def initialize(string)
    @string = string
  end

  def nice?
    return false unless has_three_vowels?
    return false unless includes_pair?
    return false if includes_prohibited_pair?
    true
  end

  private

  def includes_prohibited_pair?
    %w(ab cd pq xy).any? { |pair| string.include?(pair) }
  end

  def includes_pair?
    string.chars.reduce do |last, char|
      return true if last == char
      char
    end
    false
  end

  def has_three_vowels?
    vowel_count = string.chars.reduce(0) do |memo, char|
      memo += 1 if %w(a e i o u).include?(char)
      memo
    end
    vowel_count > 2
  end
end

class AdvancedSorter
  attr_reader :string

  def initialize(string)
    @string = string
  end

  def nice?
    return false unless includes_duplicate_pair?
    return false unless includes_palendrome?
    true
  end

  def includes_palendrome?
    string.length.times do |index|
      needle = string[index, 3]
      return false if needle.length < 3
      return true if needle == needle.reverse
    end
    false
  end

  def includes_duplicate_pair?
    string.length.times do |index|
      needle = string[index, 2]
      haystack = string[index + 2, string.length - index] || ""
      return true if haystack.include?(needle)
    end
    false
  end
end

def size_of_nice_list(manifest, sorter:)
  manifest.lines.select { |l| nice?(l, sorter: sorter) }.count
end
