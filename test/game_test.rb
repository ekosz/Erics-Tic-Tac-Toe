require 'test_helper'


class GameTest < MiniTest::Unit::TestCase

  class TerminalGameMock
    def initialize(board)
      @board = board
    end
    def get_move_from_user
      TicTacToe::MinimaxStrategy.new(@board, 'o').solve
    end
    def update_board; end
    def display_text(text); end
    def update_board; end
    def computer_goes_first?; true end
    def play_again?; false end
    def select(choices); choices.first end
  end

  def setup
    @game = TicTacToe::Game.new(3, TerminalGameMock)
    @game.instance_variable_set("@computer_letter", "x")
    @game.instance_variable_set("@human_letter", "o")
  end

  def test_run_does_not_raise_error
    success = true
    begin
      @game.run
    rescue => e
      success = false
      message = e.message
    end
    assert success, "Main game loop raised error: #{message}"
  end
end
