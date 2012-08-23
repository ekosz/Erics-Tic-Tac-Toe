module TicTacToe
  module Player
    HUMAN = 'human'
    COMPUTER = 'computer'

    def self.build(params)
      return Player::Human.new(params) if params['type'] == HUMAN

      Player::Computer.new(params)
    end

  end
end
