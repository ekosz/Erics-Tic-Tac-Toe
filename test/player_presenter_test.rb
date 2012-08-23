require 'test_helper'

class PlayerPresenterTest < MiniTest::Unit::TestCase
  def setup
    @player_mock = OpenStruct.new(letter: 'x', type: 'mock')
  end

  def test_move_json
    assert_equal({letter: 'x', type: 'mock', move: '1'}.to_json,
                 TicTacToe::Presenter::Player.new(@player_mock).move_json('1'))
  end
end
