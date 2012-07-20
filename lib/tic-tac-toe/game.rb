#This is a computer that will play a perfect game of tic-tac-toe
#Author: Eric Koslow

require_relative 'game_types/terminal_game'
require_relative 'strategies/threebythree_stategy'
require_relative 'strategies/minimax_stategy'
require_relative 'potential_state'

module TicTacToe
  # The main director of the program
  # Directs its gametype when to retrieve information from the user
  class Game
    Solvers = Solver.subclasses

    def initialize(size=3, type=TerminalGame)
      @size, @type = size, type
    end

    def run
      loop do
        @board = Board.new(nil, @size)
        @interface = @type.new(@board)

        setup_game

        main_game_loop

        break unless @interface.play_again?
      end
    end

    private

    def setup_game
      @solver = @interface.select(Solvers)

      if @interface.computer_goes_first?
        @human_letter = X
        @computer_letter = O
        play_move *get_move_from_computer, @computer_letter
      else
        @computer_letter = X
        @human_letter = O
      end

      @interface.update_board
    end

    def main_game_loop
      loop do
        play_move *@interface.get_move_from_user, @human_letter
        @interface.update_board
        break if game_over?

        @interface.display_text("Computer's move (#{@computer_letter}):")
        play_move *get_move_from_computer, @computer_letter
        @interface.update_board
        break if game_over?
      end
    end
    
    def game_over?
      if @board.solved?
        @interface.display_text("#{@board.winner} won!")
        true
      elsif @board.full?
        @interface.display_text("Cats game!")
        true
      else
        false
      end
    end

    def get_move_from_computer
      @solver.new(@board, @computer_letter).solve
    end

    def play_move(column, row, letter)
      @board.play_at(column, row, letter)
    end

  end
end
