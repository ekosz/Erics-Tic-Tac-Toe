# Third Party Requies

# Module wide methods / constants
module TicTacToe
  X = 'x'.freeze
  O = 'o'.freeze

  def self.number_to_cords(num, size)
    num = num.to_i
    num -= 1
    [num % size, num/size]
  end

end

# Internal Project Requires
require 'tic_tac_toe/board'
require 'tic_tac_toe/game'
require 'tic_tac_toe/player'
require 'tic_tac_toe/presenters/game_presenter'
require 'tic_tac_toe/presenters/player_presenter'
