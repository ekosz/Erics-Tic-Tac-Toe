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
  end

  def test_can_play_a_entire_game
    @game.run
    assert @game.board.solved?
  end
end
