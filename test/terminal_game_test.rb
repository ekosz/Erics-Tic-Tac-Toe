require 'test_helper'
require 'stringio'

class TerminalGameTest < MiniTest::Unit::TestCase

  class IoMock
    attr_reader :output

    def initialize(output=nil)
      @input = output
    end

    def gets
      @input
    end

    def puts(text); @output = text end
    def print(text); @output = text end
  end

  def test_computer_goes_first
    assert TicTacToe::TerminalGame.new(nil, IoMock.new("s")).computer_goes_first?
    refute TicTacToe::TerminalGame.new(nil, IoMock.new("f")).computer_goes_first?
  end

  def test_get_move_from_user
    game = TicTacToe::TerminalGame.new(TicTacToe::Board.new, IoMock.new("1"))
    assert_equal [0, 0], game.get_move_from_user

    game = TicTacToe::TerminalGame.new(TicTacToe::Board.new, IoMock.new("9"))
    assert_equal [2, 2], game.get_move_from_user
  end

  def test_play_again
    game = TicTacToe::TerminalGame.new(nil, IoMock.new("y"))
    assert game.play_again?

    game = TicTacToe::TerminalGame.new(nil, IoMock.new("n"))
    refute game.play_again?
  end

  def test_update_board
    mock = IoMock.new
    game = TicTacToe::TerminalGame.new("FooBar", mock)
    game.update_board

    assert_equal "FooBar", mock.output
  end

  def test_display_text
    mock = IoMock.new
    game = TicTacToe::TerminalGame.new(nil, mock)
    game.display_text("FooBar")

    assert_equal "FooBar", mock.output
  end

  def test_select_solver
    mock = IoMock.new("1")
    game = TicTacToe::TerminalGame.new(nil, mock)
    assert_equal "FooBar", game.select(["FooBar", "BarFoo"])

    mock = IoMock.new("2")
    game = TicTacToe::TerminalGame.new(nil, mock)
    assert_equal "BarFoo", game.select(["FooBar", "BarFoo"])
  end
end
