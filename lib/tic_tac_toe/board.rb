module TicTacToe
  # The main class for managing the state of the game board
  # The board data is represented at a two dimensional array
  # It provides helper methods for access the data
  class Board

    attr_accessor :grid

    def initialize(size=3)
      #[[ nil, nil, nil],
      # [ nil, nil, nil],
      # [ nil, nil, nil]]
      @grid = Array.new(size) { Array.new(size) { nil } }
    end

    def get_cell(row, column)
      @grid[column][row]
    end

    # Returns the corners of the empty cells
    def empty_positions(&block)
      positions = []
      each_position do |row, column|
        next if get_cell(row, column)
        yield(row, column) if block_given?
        positions << [row, column]
      end
      positions
    end

    # Plays a letter at a position, unless that position has already been taken
    def play_at(row, column, letter)
      @grid[column][row] ||= letter
      self
    end

    # Returns true if the grid is empty
    def empty?
      each_cell do |cell|
        return false if cell
      end
      true
    end

    # Returns true if the grid only has one element
    def only_one?
      counter = 0
      each_cell do |cell|
        counter += 1 if cell
        return false if counter >= 2
      end
      counter == 1
    end

    # Returns true if every cell is set to a value
    def full?
      each_cell do |cell|
        return false unless cell
      end
      true
    end

    # Returns true if the board has a wining pattern
    def solved?
      letter = won_across?
      return letter if letter
      letter = won_up_and_down?
      return letter if letter
      letter = won_diagonally?
      return letter if letter
      false
    end

    def winner
      solved?
    end

    def to_s
      output = ["-----------\n"]
      @grid.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          output << "#{cell || ((i*@grid.size)+j+1)} | #{"\n" if j==@grid.size-1}"
        end
      end
      output << ["-----------\n\n"]
      output.join
    end

    # Preform a deep clone of the board
    def clone
      board = Board.new
      board.grid = @grid.map { |row| row.map { |cell| cell } }
      board
    end

    def size
      @grid.size
    end

private 

    def each_cell(&block)
      @grid.each do |row|
        row.each do |cell|
          yield(cell)
        end
      end
    end

    def each_position(&block)
      @grid.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          yield(y, x)
        end
      end
    end

    def won_across?(grid = @grid)
      winning_letter = false
      grid.each do |row|
        winning_letter = row[0] if winning_group?(row)
      end
      winning_letter
    end

    def won_up_and_down?
      won_across?(@grid.transpose)
    end

    def won_diagonally?
      right_limit = @grid.size-1
      base = (0..right_limit)
      
      letter = create_and_check_group(base) { |i| @grid[i][i] }
      return letter if letter
      letter = create_and_check_group(base) { |i| @grid[i][right_limit-i] }
      return letter if letter

      false
    end

    def create_and_check_group(base, &block)
      group = base.collect { |i| yield(i) }
      return group[0] if winning_group?(group)
      false
    end

    def winning_group?(group)
      !group.any? { |cell| cell.nil? } && group.uniq.size == 1
    end

  end
end
