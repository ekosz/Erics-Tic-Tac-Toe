module TicTacToe

  class HumanPlayer 
    attr_reader :letter

    def initialize(params)
      @letter, @move = params['letter'], params['move']
    end

    def get_move(_board)
      move = @move
      @move = nil
      move
    end

    def has_next_move?
      !!@move
    end

  end

end
