require 'test_helper'

class GameTest < MiniTest::Unit::TestCase
  def setup
    @game = TicTacToe::Game.new
    @game.instance_variable_set("@computer_letter", "x")
    
    # Mock out user move from user
    game_type = @game.instance_variable_get("@game_type")
    def game_type.get_move_from_user!;  end
    # Mock out output
    def game_type.update_board; end
    def game_type.display_text(text); end
    def @game.update_board; end
  end

  def test_main_game_loop_doesnt_raise_error
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
