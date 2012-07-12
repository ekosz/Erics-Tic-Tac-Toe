require 'test_helper'

class MinimaxStrategyTest < MiniTest::Unit::TestCase
  def setup
    board     = TicTacToe::Board.new([[ 'x','x','x' ], 
                                       [ 'o','x','o' ], 
                                       [ 'o','x','x' ] ]) 

    bad_board = TicTacToe::Board.new([[ 'o','o','o' ], 
                                       [ 'o','o','o' ], 
                                       [ 'o','o','o'] ]) 

    zero_board =TicTacToe::Board.new([[ 'o','x','o' ], 
                                       [ 'o','x','o' ], 
                                       [ 'x','o','x' ] ]) 

    @good_state = TicTacToe::Minimax::GameState.new(board, 'x')
    @bad_state = TicTacToe::Minimax::GameState.new(bad_board, 'x')
    @zero_state = TicTacToe::Minimax::GameState.new(zero_board, 'x')

    @evaluator = TicTacToe::Minimax::TicTacToeEvaluator
  end

  def test_positive_score
    assert_equal 1, @evaluator.score(@good_state)
  end

  def test_negetive_score
    assert_equal -1, @evaluator.score(@bad_state)
  end

  def test_zero_score
    assert_equal 0, @evaluator.score(@zero_state)
  end
end
