require 'tic_tac_toe/player'

module TicTacToe
  module Player
    class Computer
      include MoveJson

      attr_reader :letter

      def initialize(params, solver=Strategy::MinimaxStrategy)
        @letter = params['letter'] || params[:letter]
        @solver = solver
      end

      def get_move(board)
        @solver.new(board, @letter).solve
      end

      def has_next_move?
        true
      end

      def type
        Player::COMPUTER
      end

    end
  end
end
