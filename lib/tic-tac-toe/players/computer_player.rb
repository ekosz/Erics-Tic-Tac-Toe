module TicTacToe

  class ComputerPlayer
    attr_reader :letter

    def initialize(params, solver=Minimax)
      @letter = params['letter']
      @solver = solver
    end

    def get_move(board)
      @solver.new(board, @letter).best_move
    end

    def has_next_move?
      true
    end

  end


end
