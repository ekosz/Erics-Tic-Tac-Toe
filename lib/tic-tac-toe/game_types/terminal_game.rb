module TicTacToe
  # Terminal GameType
  # Interacts with the user through the termial
  # Uses puts for output, and gets for input
  class TerminalGame
    # Internal Error used when a user tries pulling an illegal move
    class IllegalMove < RuntimeError
    end

    def initialize(board)
      @board = board
    end

    def computer_goes_first?
      unless get_input("Would you like to play first or second? (f/s)") =~ 
                        /^(f|first)$/i
        @human_letter = X
        true
      else
        @human_letter = O
        false
      end
    end

    def get_move_from_user!
      cords = get_cords_from_user

      raise IllegalMove.new("That cell is already taken") unless empty_cell?(cords)

      @board.play_at(*cords_with_letter(cords, @human_letter))
    rescue IllegalMove => error
      display_text "Illegal Move: #{error.message}. Please try again"
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

    def get_input(text)
      print text + ' '
      gets.chomp
    end

    def empty_cell?(cords)
      !@board.get_cell(*cords)
    end

    def get_cords_from_user
      input = get_input("Your move (#{@human_letter}) (1-9):")
      raise IllegalMove.new("That cell is already taken") unless input =~ /^\d$/
      cord_from_num(input.to_i)
    end

    def cord_from_num(num)
      num -= 1
      [num % Board::SIZE, num/Board::SIZE]
    end

    def cords_with_letter(cords, letter)
      Array(cords) + Array(letter)
    end
  end

end
