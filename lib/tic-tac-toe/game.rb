#This is a computer that will play a perfect game of tic-tac-toe
#Author: Eric Koslow

require_relative 'game_types/terminal_game'

module TicTacToe
  class Game
    def initialize(type=TerminalGame)
      @board = Board.new
      @game_type = type.new(@board)
    end

    def run
      if @game_type.computer_goes_first?
        @computer_letter = O
        get_move_from_computer!
      else
        @computer_letter = X
      end

      @game_type.update_board

      loop do
        @game_type.get_move_from_user!
        @game_type.update_board
        break if game_over?

        get_move_from_computer!
        @game_type.update_board
        break if game_over?
      end

      if @game_type.play_again?
        new_game
      end
    end

    private

    def new_game
      Game.new.run
    end
    
    def game_over?
      if @board.solved?
        @game_type.display_text("You lost!")
        true
      elsif @board.full?
        @game_type.display_text("Cats game!")
        true
      else
        false
      end
    end

    def get_move_from_computer!
      Solver.new(@board, @computer_letter).next_move!
      @game_type.display_text("Computer's move (#{@computer_letter}):")
    end

  end
end
