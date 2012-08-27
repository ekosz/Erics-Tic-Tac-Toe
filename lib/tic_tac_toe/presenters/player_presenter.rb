require 'json'

module TicTacToe

  module Presenter

    class Player
      def initialize(player)
        @player = player
      end

      def move_json(move=nil)
        {:letter => @player.letter, :type => @player.type, :move => move}.to_json
      end
    end

  end

end
