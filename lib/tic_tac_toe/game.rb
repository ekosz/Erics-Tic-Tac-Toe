#This is a computer that will play a perfect game of tic-tac-toe
#Author: Eric Koslow

$: << File.expand_path(File.dirname(__FILE__) + "/game_types")
$: << File.expand_path(File.dirname(__FILE__) + "/strategies")
$: << File.expand_path(File.dirname(__FILE__) + "/players")
require 'terminal_game'
require 'three_by_three_strategy'
require 'minimax_strategy'
require 'human_player'
require 'computer_player'

module TicTacToe
  # The main director of the program
  # Directs its gametype when to retrieve information from the user
  class Game
    attr_reader :board

    attr_reader :player_moves

    def initialize(board=nil, player_1=nil, player_2=nil)
      @board = Board.new
      @board.grid = board || [[nil,nil,nil],[nil,nil,nil],[nil,nil,nil]]
      @player_1 = player_1
      @player_2 = player_2
      @current_player = @player_1 && @player_1.has_next_move? ? @player_1 : @player_2
    end

    def start
      while @current_player && (move = @current_player.get_move(@board))
        move = TicTacToe::number_to_cords(move, @board.size) unless move.is_a?(Array)

        @board.play_at(move[0], move[1], @current_player.letter)
        break if over?

        switch_player
      end
    end

    def grid
      @board.grid
    end

    def decorated_grid
      grid.each_with_index.map do |row, i|
        row.each_with_index.map do |cell, j|
          cell || ((i*3)+(j+1)).to_s
        end
      end
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

    def switch_player
      @current_player = @current_player == @player_1 ? @player_2 : @player_1
    end
    
  end
end
