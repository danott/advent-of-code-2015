require "minitest"
require "minitest/autorun"
require "pry"
require "awesome_print"

class TheTest < Minitest::Test
  def test_part_1
    assert_equal 609043, next_advent_coin("abcdef", iterator: 609_000)
    assert_equal 1048970, next_advent_coin("pqrstuv", iterator: 1_000_000)
  end

  def test_refactoring
    assert_equal 254575, next_advent_coin("bgvyzdsv")
    assert_equal 1038736, next_advent_coin("bgvyzdsv", start_with: "000000")
  end
end

def next_advent_coin(salt, iterator: 0, start_with: "00000")
  iterator += 1 until Digest::MD5.hexdigest("#{salt}#{iterator}").start_with?(start_with)
  iterator
end
