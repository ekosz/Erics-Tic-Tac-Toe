# Third Party Requies

# Module wide methods / constants
module TicTacToe
  X = 'x'.freeze
  O = 'o'.freeze
end

class Class
  def subclasses
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end
end

# Internal Project Requires
require 'tic-tac-toe/solver'
require 'tic-tac-toe/board'
require 'tic-tac-toe/game'


