module TicTacToe
  # Terminal GameType
  # Interacts with the user through the terminal
  # Uses puts for output, and gets for input
  class TerminalGame
    # Internal Error used when a user tries pulling an illegal move
    class IllegalMove < RuntimeError
    end

    def initialize(board, io=Kernel)
      @board = board
      @io = io
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

    def select(choices)
      loop do
        output = "Select the solver:\n"
        choices.each_with_index { |choice, i| output += "#{i+1}: #{choice}\n" }
        input = get_input(output)
        if input =~ /^\d+$/ and input.to_i <= choices.size
          return choices[input.to_i-1]
        end
        display_text("Not a valid choice") 
      end
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
      input = get_input("Your move (#{@human_letter}) (1-#{@board.size**2}):")
      raise IllegalMove.new("That is not a real location") unless input =~ /^\d+$/
      cord_from_num(input.to_i)
    end

    def cord_from_num(num)
      num -= 1
      [num % @board.size, num/@board.size]
    end
  end

end
