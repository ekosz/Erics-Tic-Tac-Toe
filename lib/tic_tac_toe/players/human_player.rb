module TicTacToe

  module Player
    class Human
      attr_reader :letter
      attr_writer :move

      def initialize(params)
        @letter, @move = (params['letter'] || params[:letter]), 
          (params['move'] || params[:move])
      end

      def get_move(_board)
        move = @move
        @move = nil
        move
      end

      def has_next_move?
        !!@move
      end

      def type
        Player::HUMAN
      end

    end

  end

end
