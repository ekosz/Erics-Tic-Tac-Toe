module TicTacToe
  module Player
    HUMAN = 'human'
    COMPUTER = 'computer'

    def self.build(params)
      return Player::Human.new(params) if params['type'] == HUMAN

      Player::Computer.new(params)
    end

    module MoveJson
      require 'json'
      def move_json(move=nil)
        {:letter => letter, :type => type, :move => move}.to_json
      end
    end
  end
end
