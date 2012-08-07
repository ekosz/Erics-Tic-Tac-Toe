#This is a computer that will play a perfect game of tic-tac-toe
#Author: Eric Koslow

require_relative 'game_types/terminal_game'
require_relative 'strategies/three_by_three_strategy'
require_relative 'strategies/minimax_strategy'
require_relative 'players/human_player'
require_relative 'players/computer_player'

module TicTacToe
  # The main director of the program
  # Directs its gametype when to retrieve information from the user
  class Game
    Solvers = [MinimaxStrategy, ThreeByThreeStrategy]

    attr_reader :board

    attr_reader :player_moves

    def initialize(board=nil, player_1=nil, player_2=nil)
      @board = Board.new
      @board.grid = board || [[nil,nil,nil],[nil,nil,nil],[nil,nil,nil]]
      @player_1 = player_1
      @player_2 = player_2
      play
    end

    def grid
      @board.grid
    end

    def solved?
      @board.solved?
    end

    def cats?
      @board.full? && !solved?
    end

    def winner
      @board.winner
    end

    private

    def play
      player = @player_1 && @player_1.has_next_move? ? @player_1 : @player_2

      while player && (move = player.get_move(@board)) do
        move = number_to_cords(move) unless move.is_a?(Array)

        @board.play_at(*move, player.letter)
        break if over?

        player = next_player(player)
      end

      self
    end

    def over?
      solved? || cats?
    end

    def number_to_cords(num)
      num = num.to_i
      num -= 1
      [num % @board.size, num/@board.size]
    end

    def next_player(player)
      case player
      when @player_1 then @player_2
      when @player_2 then @player_1
      end
    end
    
  end
end
