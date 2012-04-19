module TicTacToe

  # Represents a state of players move
  # This is comprised of a board and letter (player)
  class PotentialState
    def initialize(board, letter)
      @board, @letter = board, letter
    end

    def at(row, column)
      new_board = @board.clone
      new_board.play_at(row, column, @letter)
      PotentialState.new(new_board, @letter)
    end

    def solved?
      @board.solved?
    end

    def each_forking_position(&block)
      forking_positions.each { |position| yield(*position) }
    end

    def fork_exsits?
      winning_positions_count >= 2
    end

    def can_win_next_turn?
      each_position do |row, column|
        return true if at(row, column).solved?
      end
      false
    end

    def forking_positions
      positions = [] 
      each_position do |row, column|
        positions << [row, column] if at(row, column).fork_exsits?
      end
      positions
    end

private

    def winning_positions_count
      count = 0
      each_position do |row, column|
        count += 1 if at(row, column).solved?
      end
      count
    end

    def each_position(&block)
      Board::SIZE.times do |column|
        Board::SIZE.times do |row|
          yield(row, column)
        end
      end
    end

  end
end
