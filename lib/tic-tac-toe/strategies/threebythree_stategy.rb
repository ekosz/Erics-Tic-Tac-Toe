require_relative 'threebythree_implementations/brute_force_implementation'

module TicTacToe
  # Strategy used when playing on a 3x3 board
  class ThreebythreeStrategy
    def initialize(board, letter, implementation=BruteForceImplementation)
      @implementation = implementation.new(board, letter)
    end

    # The strategy is from the Wikipedia article on Tic-Tac-Toe
    # 1) Try to win
    # 2) Try to block if they're about to win
    # 3) Try to fork so you'll win next turn
    # 4) Try to block their fork so they will not win next turn
    # 5) Take the center if its not already taken
    # 6) Play the opposite corner of your opponent
    # 7) Play in an empty corner
    # 8) Play in an empty side
    def solve!
      return if @implementation.win!
      return if @implementation.block!
      return if @implementation.fork!
      return if @implementation.block_fork!
      return if @implementation.center!
      return if @implementation.oposite_corner!
      return if @implementation.empty_corner!
      return if @implementation.empty_side!
      raise Exception.new("No possible moves to play!")
    end
  end
end
