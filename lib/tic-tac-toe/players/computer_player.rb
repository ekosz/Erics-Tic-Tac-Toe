module TicTacToe
  class ComputerPlayer

    attr_reader :letter

    def initialize(letter, solver)
      @letter = letter 
      @solver = solver
    end

    def get_move(board)
      @solver.new(board, @letter).solve
    end
  end
end
