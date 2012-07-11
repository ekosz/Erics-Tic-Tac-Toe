require 'test_helper'

class MinimaxStrategyTest < MiniTest::Unit::TestCase
  def setup
    @board     = TicTacToe::Board.new([[ 'x','x','x' ], 
                                       [ 'o','x','o' ], 
                                       [ 'o','x','x' ] ]) 

    @bad_board = TicTacToe::Board.new([[ 'o','o','o' ], 
                                       [ 'o','o','o' ], 
                                       [ 'o','o','o'] ]) 

    @zero_board =TicTacToe::Board.new([[ 'o','x','o' ], 
                                       [ 'o','x','o' ], 
                                       [ 'x','o','x' ] ]) 

    @game_tree = TicTacToe::MinimaxStrategy::GameTree.new(@board, 'x')
  end

  def test_positive_score
    assert_equal 1, @game_tree.score(@board)
  end

  def test_negetive_score
    assert_equal -1, TicTacToe::MinimaxStrategy::GameTree.new(nil, 'x').score(@bad_board)
  end

  def test_zero_score
    assert_equal 0, @game_tree.score(@zero_board)
  end
end
