require 'test_helper'

class BoardMock; end

class PlayerTest < MiniTest::Unit::TestCase

  def test_build_human_player
    assert_equal TicTacToe::HumanPlayer,
                 TicTacToe::Player.build('type' => 'human').class
  end

  def test_build_computer_player
    assert_equal TicTacToe::ComputerPlayer,
                 TicTacToe::Player.build('type' => 'computer').class
  end
end

module SharedPlayerTests
  def test_gets_move
    assert_equal [0, 0], @player.get_move(BoardMock.new)
  end

  def test_letter
    assert_equal 'x', @player.letter
  end

  def test_has_next_move
    assert @player.has_next_move?
  end
end

class HumanPlayerTest < MiniTest::Unit::TestCase
  def setup
    @player = TicTacToe::HumanPlayer.new('letter' => "x", 'move' => [0,0])
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
    @player = TicTacToe::ComputerPlayer.new({'letter' => "x"}, SolverMock)
  end

  include SharedPlayerTests
end
