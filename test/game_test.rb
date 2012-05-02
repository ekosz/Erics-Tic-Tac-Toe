require 'test_helper'

class GameTest < MiniTest::Unit::TestCase
  def setup
    @game = TicTacToe::Game.new
    @game.instance_variable_set("@computer_letter", "x")
  end

  def test_main_game_loop_doesnt_raise_error
    # Mock out user move from user
    game_type = @game.instance_variable_get("@game_type")
    def game_type.get_move_from_user!
      @game.method(:get_move_from_computer!)
    end

    success = true
    begin
      @game.send(:main_game_loop)
    rescue => e
      success = false
      message = e.message
    end
    assert success, "Main game loop raised error: #{message}"
  end
end
