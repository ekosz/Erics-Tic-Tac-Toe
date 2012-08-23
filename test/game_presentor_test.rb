require 'test_helper'

class GamePresentorTest < MiniTest::Unit::TestCase
  def setup
    @game = TicTacToe::Game.new
    @presentor = TicTacToe::Presenter::Game.new(@game)
  end

  def test_grid
    assert_equal [%w(1 2 3), %w(4 5 6), %w(7 8 9)], @presentor.grid
  end

  def test_grid_with_moves
    @game = TicTacToe::Game.new([['x', nil, nil], [nil, nil, nil], [nil, nil, nil]])
    @presentor = TicTacToe::Presenter::Game.new(@game)

    assert_equal [%w(x 2 3), %w(4 5 6), %w(7 8 9)], @presentor.grid
  end
end
