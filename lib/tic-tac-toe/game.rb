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

    attr_reader :player_moves

    def initialize(params={})
      @board = Board.new
      @board.grid = params[:board] || [[nil,nil,nil],[nil,nil,nil],[nil,nil,nil]]

      @player_moves = {
        'x' => params[:x],
        'o' => params[:o]
      }
      @first = params[:first] || 'x'
    end

    def play
      player_sorter = proc { |player, move| player == @first ? -1 : 1 }
      @player_moves.sort_by(&player_sorter).each  do |player, move|
        next if move == 'skip'

        move = move_via_computer(player) unless move

        move = number_to_cords(move) unless move.is_a?(Array)

        @board.play_at(*move, player)
        break if over?
      end
      self
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

    def over?
      solved? || cats?
    end

    def move_via_computer(letter)
      MinimaxStrategy.new(@board, letter).solve
    end


    def number_to_cords(num)
      num = num.to_i
      num -= 1
      [num % @board.size, num/@board.size]
    end
    
  end
end
