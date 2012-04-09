# Brute Force Implementation for the Three by Three Strategy
# This implementation uses loops to try a change all of the board values and
# checking the result
#
# For example, win! is implemented by trying every cell, and checking if
# it was a winning solution
module TicTacToe
  class BruteForceImplementation

    def initialize(board, letter)
      @board, @letter = board, letter
    end

    # Try placing letter at every available position
    # If the board is solved, do that
    def win!
      each_position do |x, y|
        temp_board = @board.clone
        temp_board.play_at(x, y, @letter)
        if temp_board.solved?
          @board.play_at(x, y, @letter)
          return true
        end
      end
      false
    end

    # Try placing the opponent's letter at every available position
    # If the board is solved, block them at that position
    def block!(board = @board, letter = @letter)
      each_position do |x, y|
        temp_board = board.clone
        temp_board.play_at(x, y, other_player(letter))
        if temp_board.solved?
          board.play_at(x, y, letter)
          return true
        end
      end
      false
    end

    # Try placing the letter at every position.
    # If there are now two winning solutions for next turn, go there
    def fork!
      each_forking_position do |x, y|
        @board.play_at(x, y, @letter)
        return true
      end
      false
    end

    # Try placing the opponent's letter at every position.
    # If there are now two winning solutions for next turn, block them there
    def block_fork!(board = @board)
      each_forking_position(other_player) do |x, y|
        temp_board = board.clone
        temp_board.play_at(x,y,@letter)
        # Search for the elusive double fork
        each_forking_position(other_player, temp_board) do |x, y|
          return force_a_block        
        end
        board.play_at(x, y, @letter)
        return true
      end
      false
    end

    def center!
      return false if @board.center_cell

      @board.center_cell = @letter
      true
    end

    # Cycle through all of the corners looking for the opponent's letter
    # If one is found, place letter at the opposite corner
    def oposite_corner!
      @board.corners.each_with_index do |corner, index|
        if corner == other_player
          case index
          when 0 # Top Left
            next if @board.get_cell(Board::SIZE-1, Board::SIZE-1)
            @board.play_at(Board::SIZE-1, Board::SIZE-1, @letter)
            return true
          when 1 # Top Right
            next if @board.get_cell(0, Board::SIZE-1)
            @board.play_at(0, Board::SIZE-1, @letter)
            return true
          when 2 # Bottom Right
            next if @board.get_cell(0, 0)
            @board.play_at(0, 0, @letter)
            return true
          when 3 # Bottom Left
            next if @board.get_cell(Board::SIZE-1, 0)
            @board.play_at(Board::SIZE-1, 0, @letter)
            return true
          else
            raise Exception.new("Board#corners returned more than 4")
          end
        end
      end
      false
    end

    # Cycle though all of the corners, until one is found that is empty
    def empty_corner!
      @board.corners.each_with_index do |corner, index|
        unless corner
          case index
          when 0 # Top Left
            @board.play_at(0, 0, @letter)
            return true
          when 1 # Top Right
            @board.play_at(Board::SIZE-1, 0, @letter)
            return true
          when 2 # Bottom Right
            @board.play_at(Board::SIZE-1, Board::SIZE-1, @letter)
            return true
          when 3 # Bottom Left
            @board.play_at(0, Board::SIZE-1, @letter)
            return true
          else
            raise Exception.new("Board#corners returned more than 4")
          end
        end
      end
      false
    end

    # Place letter at a random empty cell, at this point it should only be sides left
    def empty_side!
      @board.any_empty_position do |x, y|
        @board.play_at(x, y, @letter)
        return true 
      end
      false
    end

    private

    def other_player(letter = @letter)
      letter == X ? O : X
    end

    def fork_exsits?(x, y, letter = @letter, board = @board)
      (count = can_win_next_turn?(x, y, letter, board)) && count >= 2
    end

    def each_position(&block)
      Board::SIZE.times do |y|
        Board::SIZE.times do |x|
          yield(x, y)
        end
      end
    end

    def each_forking_position(letter = @letter, board = @board, &block)
      each_position do |x, y|
        if fork_exsits?(x, y, letter, board)
          yield(x, y)
        end
      end
    end

    def can_win_next_turn?(x, y, letter = @letter, board = @board)
      count = 0
      temp_board = board.clone
      temp_board.play_at(x,y,letter)
      each_position do |x, y|
        inner_loop_board = temp_board.clone
        inner_loop_board.play_at(x, y, letter)
        count += 1 if inner_loop_board.solved?
      end
      return count == 0 ? false : count
    end

    def force_a_block
      # Force them to block without creating another fork
      each_position do |x, y|
        if can_win_next_turn?(x, y)
          temp_board = @board.clone
          temp_board.play_at(x, y, @letter)
          raise Exception.new("Couldn't force a block") unless block!(temp_board, other_player)
          # Did I just create another fork with that block?
          if fork_exsits?(x, y, other_player, temp_board)
            next
          else
            @board.play_at(x, y, @letter)
            return true
          end
        end
      end
      raise Exception.new("No position found to block the fork")
    end

  end
end
