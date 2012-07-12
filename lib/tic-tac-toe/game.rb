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
    def initialize(type=TerminalGame)
      @board = Board.new
      @game_type = type.new(@board)
    end

    def run
      setup_game

      main_game_loop

      if @game_type.play_again?
        new_game
      end
    end

    private

    def new_game
      @board = Board.new
      @game_type = @game_type.class.new(@board)
      run
    end

    def setup_game
      if @game_type.computer_goes_first?
        @computer_letter = O
        get_move_from_computer!
      else
        @computer_letter = X
      end

      @game_type.update_board
    end

    def main_game_loop
      loop do
        @game_type.get_move_from_user!
        @game_type.update_board
        break if game_over?

        get_move_from_computer!
        @game_type.update_board
        break if game_over?
      end
    end
    
    def game_over?
      if @board.solved?
        @game_type.display_text("#{@board.winner} won!")
        true
      elsif @board.full?
        @game_type.display_text("Cats game!")
        true
      else
        false
      end
    end

    def get_move_from_computer!
      MinimaxStrategy.new(@board, @computer_letter).solve!
      @game_type.display_text("Computer's move (#{@computer_letter}):")
    end

  end
end
