module TicTacToe

  module Player

    class Computer
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
