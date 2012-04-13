require_relative 'strategies/threebythree_stategy'

module TicTacToe
  # Finds the next best move using a strategy
  class Solver

    def initialize(board, letter, strategy=ThreebythreeStrategy)
      @strategy = strategy.new(board, letter)
    end

    # Performs the next perfect move and updates the board as a side effect
    def next_move!
      @strategy.solve!
    end

  end
end
