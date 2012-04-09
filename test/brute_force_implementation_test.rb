require 'test_helper'

class BruteForceImplementationTest < MiniTest::Unit::TestCase
  def setup
    TicTacToe::BruteForceImplementation.instance_eval { attr_accessor :board }
    @implementation = TicTacToe::BruteForceImplementation.new(TicTacToe::Board.new, 'x')
  end

  def test_can_win_next_turn
    # Test private method that it returns the correct amount of winning moves

    set_grid([[ 'x', nil, nil], [nil, nil, nil], [nil, nil, nil] ])
    assert_equal 1, @implementation.send(:can_win_next_turn?, 0, 1)

    # 1 | 2 | x
    # 4 | o | 6
    # 7 | x | 9
    set_grid([[ nil, nil, 'x'], [nil, 'o', nil], [nil, 'x', nil] ])
    assert_equal 2, @implementation.send(:can_win_next_turn?, 2, 2)
  end

  def set_grid(grid)
    @implementation.board.instance_variable_set("@grid", grid)
  end
end
