#This is a computer that will play a perfect game of tic-tac-toe
#Author: Eric Koslow

require_relative 'game_types/terminal_game'
require_relative 'strategies/threebythree_strategy'
require_relative 'strategies/minimax_strategy'
require_relative 'players/human_player'
require_relative 'players/computer_player'

module TicTacToe
  # The main director of the program
  # Directs its gametype when to retrieve information from the user
  class Game
    Solvers = [MinimaxStrategy, ThreebythreeStrategy]

    attr_reader :board

    def initialize(size=3, type=TerminalGame)
      @size, @type = size, type
    end

    def run
      setup_game
      main_game_loop
    end

    private

    def setup_game
      @board = Board.new(@size)
      @interface = @type.new(@board)

      solver = @interface.select(Solvers)

      if @interface.computer_goes_first?
        set_players(ComputerPlayer.new(X, solver), HumanPlayer.new(O, @type))
        return
      end

      set_players(HumanPlayer.new(X, @type), ComputerPlayer.new(O, solver))
    end

    def main_game_loop
      loop do
        @interface.update_board

        play_move @current_player.get_move(@board), @current_player.letter

        @current_player = next_player

        if game_over?
          @interface.update_board
          break unless @interface.play_again?
          setup_game
        end

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

    def play_move(move, letter)
      @board.play_at(*move, letter)
    end

    def set_players(player_1, player_2)
      @current_player = @player_1 = player_1
      @player_2 = player_2
    end

    def next_player
      case @current_player
      when @player_1 then @player_2
      when @player_2 then @player_1
      end
    end

  end
end
