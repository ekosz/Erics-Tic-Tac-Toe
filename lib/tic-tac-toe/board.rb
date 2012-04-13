require_relative 'winning_group_checker'

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

    def get_cell(x, y)
      @grid[y][x]
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
      each_position do |x, y|
        next if get_cell(x, y)
        yield(x, y)
      end
    end

    # Plays a letter at a position, unless that position has already been taken
    def play_at(x, y, letter)
      # Weird bug I found in ruby 1.9.3-p0
      # Given a @grid of [ [nil,nil,nil], [nil,nil,nil], [nil,nil,nil] ]
      # If you call @grid[0][0] = 'x'
      # I aspect @grid to be [ ['x',nil,nil], [nil,nil,nil], [nil,nil,nil] ]
      # What happens is that @grid is [ ['x',nil,nil], ['x',nil,nil], ['x',nil,nil] ]
      # This is a workaround for that
      inner = @grid[y].clone
      inner[x] ||= letter
      @grid[y] = inner
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
      return true if won_across?
      return true if won_up_and_down?
      return true if won_diagonally?
      false
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
          yield(x, y)
        end
      end
    end

    def won_across?(grid = @grid)
      grid.any? do |row|
        WinningGroupChecker.new(row).won?
      end
    end

    def won_up_and_down?
      won_across?(@grid.transpose)
    end

    def won_diagonally?
      right_limit = SIZE-1
      base = (0..right_limit)
      
      return true if create_and_check_group(base) { |i| @grid[i][i] }
      return true if create_and_check_group(base) { |i| @grid[i][right_limit-i] }

      false
    end

    def create_and_check_group(base, &block)
      group = base.collect { |i| yield(i) }
      return true if WinningGroupChecker.new(group).won?
      false
    end

  end
end
