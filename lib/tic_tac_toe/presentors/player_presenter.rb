require 'json'

module TicTacToe
  class PlayerPresenter
    def initialize(player)
      @player = player
    end

    def move_json(move=nil)
      {letter: @player.letter, type: @player.type, move: move}.to_json
    end
  end
end
