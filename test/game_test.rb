require 'test_helper'


class GameTest < MiniTest::Unit::TestCase

  def test_grid
    game = TicTacToe::Game.new

    assert_equal game.grid, empty_grid
  end

  def test_an_empty_game_is_not_solved
    game = TicTacToe::Game.new

    refute game.solved?
  end

  def test_a_full_grid_is_cats
    # x o x
    # x o x
    # o x o
    game = TicTacToe::Game.new(board:[%w(x o x), %w(x o x), %w(o x o)])

    assert game.cats?
  end

  def test_winner
    game = TicTacToe::Game.new(board:[%w(x x x), [nil,nil,nil], [nil, nil, nil]])

    assert_equal 'x', game.winner
  end

  def test_setting_a_players_move
    game = TicTacToe::Game.new(x: [0, 0]).play

    assert_equal 'x', game.board.get_cell(0, 0)
  end

  def test_set_move_via_computer
    game = TicTacToe::Game.new.play

    assert_equal 7, game.board.empty_positions.size
  end

  def test_skip_a_players_turn
    game = TicTacToe::Game.new(board: empty_grid, o: "skip").play

    assert game.board.only_one?
  end
  

  def empty_grid(size=3)
    Array.new(size) { Array.new(size) { nil } }
  end
end
