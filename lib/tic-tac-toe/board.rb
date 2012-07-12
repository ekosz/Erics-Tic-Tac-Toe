module TicTacToe
  # The main class for managing the state of the game board
  # The board data is represented at a two dimensional array
  # It provides helper methods for access the data
  class Board

    SIZE = 3.freeze

    def initialize(grid=nil)
      #[[ nil, nil, nil],
      # [ nil, nil, nil],
      # [ nil, nil, nil]]
      @grid = grid || [ [nil] * SIZE ] * SIZE
    end

    def get_cell(row, column)
      @grid[column][row]
    end

    # Returns the closest middle cell
    def center_cell
      mid = @grid.size/2
      get_cell(mid, mid)
    end

    # Sets the closet middle cell if its not already set
    def center_cell=(letter)
      mid = @grid.size/2
      play_at(mid, mid, letter)
    end

    # Returns the corners of the grid
    def corners
      top_row = @grid.first
      bottom_row = @grid.last
      [top_row.first,     # Top Left
       top_row.last,      # Top Right
       bottom_row.last,   # Bottom Right
       bottom_row.first]  # Bottom Left
    end

    # Returns the corners of the empty cells
    def any_empty_position(&block)
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
      # Weird bug I found in ruby 1.9.3-p0
      # Given a @grid of [ [nil,nil,nil], [nil,nil,nil], [nil,nil,nil] ]
      # If you call @grid[0][0] = 'x'
      # I aspect @grid to be [ ['x',nil,nil], [nil,nil,nil], [nil,nil,nil] ]
      # What happens is that @grid is [ ['x',nil,nil], ['x',nil,nil], ['x',nil,nil] ]
      # This is a workaround for that
      inner = @grid[column].clone
      inner[row] ||= letter
      @grid[column] = inner
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
          output << "#{cell || ((i*3)+j+1)} | #{"\n" if j==2}"
        end
      end
      output << ["-----------\n\n"]
      output.join
    end

    # Preform a deep clone of the board
    # FIXME: This only works for SIZE=3
    def clone
      Board.new(@grid.map { |row| row.map { |cell| cell } })
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
      right_limit = SIZE-1
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
