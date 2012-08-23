module TicTacToe
  module GameType
    # Terminal GameType
    # Interacts with the user through the terminal
    # Uses puts for output, and gets for input
    class Terminal
      # Internal Error used when a user tries pulling an illegal move
      class IllegalMove < RuntimeError
      end

      def initialize(board, io=Kernel)
        @board = board
        @io = io
      end

      def computer_goes_first?
        input = get_input("Would you like to play first or second? (f/s)")

        return true unless input =~ /^(f|first)$/i
        false
      end

      def get_move_from_user
        cords = get_cords_from_user

        raise IllegalMove.new("That cell is already taken") unless empty_cell?(cords)

        cords
      rescue IllegalMove => error
        display_text "Illegal Move: #{error.message}. Please try again"
        retry
      end

      def play_again?
        input = get_input "Play again? (y/n)"
        input =~ /^(y|yes)$/i
      end

      def update_board
        @io.puts @board
      end

      def display_text(text)
        @io.puts text
      end

      private

      def get_input(text)
        @io.print text + ' '
        @io.gets.chomp
      end

      def empty_cell?(cords)
        !@board.get_cell(*cords)
      end

      def get_cords_from_user
        input = get_input("Your move (1-#{@board.size**2}):")

        raise IllegalMove.new("That is not a real location") unless input =~ /^\d+$/

        TicTacToe::number_to_cords(input, @board.size)
      end

    end
  end
end
