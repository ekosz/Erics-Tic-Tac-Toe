module TicTacToe
  # Brute Force Implementation for the Three by Three Strategy
  # This implementation uses loops to try a change all of the board values and
  # checking the result
  #
  # For example, win! is implemented by trying every cell, and checking if
  # it was a winning solution
  class BruteForceImplementation

    attr_reader :board

    def initialize(board, letter)
      @board, @letter, @state = board, letter, PotentialState.new(board, letter)
      @other_player = other_player
    end

    # Try placing letter at every available position
    # If the board is solved, do that
    def win
      each_position do |row, column|
        if @state.at(row, column).solved?
          return [row, column]
        end
      end
      false
    end

    # Try placing the opponent's letter at every available position
    # If the board is solved, block them at that position
    def block(board = @board, letter = @letter)
      state = PotentialState.new(board, other_player(letter))
      each_position do |row, column|
        if state.at(row, column).solved?
          return [row, column]
        end
      end
      false
    end

    # Try placing the letter at every position.
    # If there are now two winning solutions for next turn, go there
    def fork
      @state.each_forking_position do |row, column|
        return [row, column]
      end
      false
    end

    # Try placing the opponent's letter at every position.
    # If there are now two winning solutions for next turn, block them there
    def block_fork
      PotentialState.new(@board, @other_player).each_forking_position do |row, column|
        
        # Simulate blocking the fork
        temp_board = @board.clone
        temp_board.play_at(row, column, @letter)

        # Search for the elusive double fork
        if PotentialState.new(temp_board, @other_player).forking_positions.any?
          return force_a_block 
        end

        return [row, column]
      end
      false
    end

    def center
      return false if @board.center_cell
      [1,1]
    end

    # Cycle through all of the corners looking for the opponent's letter
    # If one is found, place letter at the opposite corner
    def oposite_corner
      first = 0
      last = @board.size - 1
      @board.corners.each_with_index do |corner, index|
        if corner == @other_player
          next if @board.get_cell(*opposite_corner_from_index(index).compact)
          return opposite_corner_from_index(index)
        end
      end
      false
    end

    # Cycle though all of the corners, until one is found that is empty
    def empty_corner
      @board.corners.each_with_index do |corner, index|
        next if corner
        return corner_from_index(index)
      end
      false
    end

    # Place letter at a random empty cell, at this point it should only be sides left
    def empty_side
      @board.any_empty_position do |row, column|
        return [row, column] 
      end
      false
    end

private

    def corner_from_index(index)
      first = 0
      last = @board.size - 1
      case index
      when 0 # Top Left
        [first, first]
      when 1 # Top Right
        [last, first]
      when 2 # Bottom Right
        [last, last]
      when 3 # Bottom Left
        [first, last]
      end 
    end

    def opposite_corner_from_index(index)
      first = 0
      last = @board.size - 1
      case index
      when 0 # Top Left
        [last, last]
      when 1 # Top Right
        [first, last]
      when 2 # Bottom Right
        [first, first]
      when 3 # Bottom Left
        [last, first]
      end
    end

    def other_player(letter = @letter)
      letter == X ? O : X
    end

    def each_position(&block)
      @board.size.times do |column|
        @board.size.times do |row|
          yield(row, column)
        end
      end
    end

    def force_a_block
      # Force them to block without creating another fork
      each_position do |row, column|
        if @state.at(row, column).can_win_next_turn?

          # Simulate forcing them to block
          temp_board = @board.clone
          temp_board.play_at(row, column, @letter)
          temp_board.play_at(*block(temp_board, @other_player), @other_player)
          
          # Did I just create another fork with that block?
          next if PotentialState.new(temp_board, @other_player).fork_exsits?

          return [row, column]

        end
      end
    end

  end
end
