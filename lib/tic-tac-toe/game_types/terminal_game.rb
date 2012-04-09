module TicTacToe
  class TerminalGame
    class IllegalMove < RuntimeError
    end

    def initialize(board)
      @board = board
    end

    def computer_goes_first?
      print "Would you like to play first or second? (f/s) "
      input = gets.chomp
      unless input =~ /^(f|first)$/i
        @human_letter = X
        true
      else
        @human_letter = O
        false
      end
    end

    def get_move_from_user!
      print "Your move (#{@human_letter}) (1-9): "
      input = gets.chomp

      if input =~ /^\d$/ 
        cords = cord_from_num(input.to_i)
        if !@board.get_cell(*cords)
          @board.play_at(*(cords+[@human_letter]))
        else
          raise IllegalMove.new("That cell is already taken")
        end
      else
        raise IllegalMove.new("Must be a single number")
      end
    rescue IllegalMove => e
      display_text "Illegal Move: #{e.message}. Please try again"
      get_move_from_user!
    end

    def play_again?
      print "Play again? (y/n) "
      input = gets.chomp
      input =~ /^(y|yes)$/i
    end

    def update_board
      puts @board
    end

    def display_text(text)
      puts text
    end

    private

    def cord_from_num(num)
      num -= 1
      [num % Board::SIZE, num/Board::SIZE]
    end
  end

end
