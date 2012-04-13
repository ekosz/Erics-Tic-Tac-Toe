module TicTacToe
  # Brute Force Implementation for the Three by Three Strategy
  # This implementation uses loops to try a change all of the board values and
  # checking the result
  #
  # For example, win! is implemented by trying every cell, and checking if
  # it was a winning solution
  class BruteForceImplementation

    def initialize(board, letter)
      @board, @letter = board, letter
    end

    # Try placing letter at every available position
    # If the board is solved, do that
    def win!
      each_position do |row, column|
        temp_board = create_temp_board_with(@board, row, column, @letter)
        if temp_board.solved?
          @board.play_at(row, column, @letter)
          return true
        end
      end
      false
    end

    # Try placing the opponent's letter at every available position
    # If the board is solved, block them at that position
    def block!(board = @board, letter = @letter)
      each_position do |row, column|
        temp_board = create_temp_board_with(board, row, column, other_player(letter))
        if temp_board.solved?
          board.play_at(row, column, letter)
          return true
        end
      end
      false
    end

    # Try placing the letter at every position.
    # If there are now two winning solutions for next turn, go there
    def fork!
      each_forking_position do |row, column|
        @board.play_at(row, column, @letter)
        return true
      end
      false
    end

    # Try placing the opponent's letter at every position.
    # If there are now two winning solutions for next turn, block them there
    def block_fork!(board = @board)
      each_forking_position(other_player) do |row, column|
        temp_board = create_temp_board_with(board, row, column, @letter)
        
        # Search for the elusive double fork
        return force_a_block if forking_positions(other_player, temp_board).any?

        board.play_at(row, column, @letter)
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
      first = 0
      last = Board::SIZE - 1
      @board.corners.each_with_index do |corner, index|
        if corner == other_player
          next if @board.get_cell(*opposite_corner_from_index(index).compact)
          @board.play_at(*opposite_corner_from_index(index, @letter))
          return true
        end
      end
      false
    end

    # Cycle though all of the corners, until one is found that is empty
    def empty_corner!
      @board.corners.each_with_index do |corner, index|
        next if corner
        @board.play_at(*corner_from_index(index, @letter))
        return true
      end
      false
    end

    # Place letter at a random empty cell, at this point it should only be sides left
    def empty_side!
      @board.any_empty_position do |row, column|
        @board.play_at(row, column, @letter)
        return true 
      end
      false
    end

    private

    def corner_from_index(index, letter)
      first = 0
      last = Board::SIZE - 1
      case index
      when 0 # Top Left
        [first, first, letter]
      when 1 # Top Right
        [last, first, letter]
      when 2 # Bottom Right
        [last, last, letter]
      when 3 # Bottom Left
        [first, last, letter]
      end 
    end

    def opposite_corner_from_index(index, letter=nil)
      first = 0
      last = Board::SIZE - 1
      case index
      when 0 # Top Left
        [last, last, letter]
      when 1 # Top Right
        [first, last, letter]
      when 2 # Bottom Right
        [first, first, letter]
      when 3 # Bottom Left
        [last, first, letter]
      end
    end

    def create_temp_board_with(board, row, column, letter)
      temp_board = board.clone
      temp_board.play_at(row, column, letter)
      temp_board
    end

    def other_player(letter = @letter)
      letter == X ? O : X
    end

    def fork_exsits?(row, column, letter = @letter, board = @board)
      (count = can_win_next_turn?(row, column, letter, board)) && count >= 2
    end

    def each_position(&block)
      Board::SIZE.times do |column|
        Board::SIZE.times do |row|
          yield(row, column)
        end
      end
    end

    def forking_positions(letter, board)
      positions = [] 
      each_position do |row, column|
        positions << [row, column] if fork_exsits?(row, column, letter, board)
      end
      positions
    end

    def each_forking_position(letter = @letter, board = @board, &block)
      forking_positions(letter, board).each { |position| yield(*position) }
    end

    def can_win_next_turn?(row, column, letter = @letter, board = @board)
      temp_board = create_temp_board_with(board, row, column, letter)
      count = winning_positions_count(temp_board, letter)
      return count == 0 ? false : count
    end

    def winning_positions_count(board, letter)
      count = 0
      each_position do |row, column|
        temp_board = create_temp_board_with(board, row, column, letter)
        count += 1 if temp_board.solved?
      end
      count
    end

    def force_a_block
      # Force them to block without creating another fork
      each_position do |row, column|
        if can_win_next_turn?(row, column)
          temp_board = create_temp_board_with(@board, row, column, @letter)
          block!(temp_board, other_player)
          
          # Did I just create another fork with that block?
          next if fork_exsits?(row, column, other_player, temp_board)

          @board.play_at(row, column, @letter)
          return true

        end
      end
    end

  end
end
