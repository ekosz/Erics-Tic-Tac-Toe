module TicTacToe
  class Player
    HUMAN = 'human'
    COMPUTER = 'computer'

    def self.build(params)
      return HumanPlayer.new(params) if params['type'] == HUMAN

      ComputerPlayer.new(params)
    end

  end
end
