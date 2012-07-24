require 'test_helper'

class BoardMock; end

module SharedPlayerTests
  def test_gets_move
    refute_nil @player.get_move(BoardMock.new)
  end

  def test_letter
    assert_equal 'x', @player.letter
  end
end

class HumanPlayerTest < MiniTest::Unit::TestCase
  class TerminalGameMock
    def get_move_from_user
      [0, 0]
    end
  end
  def setup
    @player = TicTacToe::HumanPlayer.new("x", TerminalGameMock)
  end

  include SharedPlayerTests
end


class ComputerPlayerTest < MiniTest::Unit::TestCase
  class SolverMock
    def solve
      [0, 0]
    end
  end

  def setup
    @player = TicTacToe::ComputerPlayer.new("x", SolverMock)
  end

  include SharedPlayerTests
end
