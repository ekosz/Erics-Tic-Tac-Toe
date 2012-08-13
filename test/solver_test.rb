require 'test_helper'

module SharedSolverTests
  def test_win_horizontally
    refute @board.solved?

    # Will win, when there is a winning move
    set_grid([[ 'x', 'x', nil], 
              [ 'o', 'o', nil], 
              [ 'x', 'o', nil] ])
    refute @board.solved? # Is not solved yet
    solve!
    assert !!@board.solved?, "Could not solve the board" # Solved it
    assert_equal 'x', @board.get_cell(2, 0) # Placed the right letter
  end

  def test_wins_across

    set_grid([[ 'x', 'o', nil], 
              [ nil, 'x', nil], 
              [ 'o', nil, nil] ])
    refute @board.solved?
    solve!
    assert !!@board.solved?
    assert_equal 'x', @board.get_cell(2, 2)
  end

  def test_wins_vertically
    
    set_grid([[ 'x', nil, 'o'], 
              [nil,  'o', 'o'], 
              [ 'x', nil, nil] ])
    refute @board.solved?
    solve!
    assert !!@board.solved?
    assert_equal 'x', @board.get_cell(0, 1)
  end

  def test_does_not_win_unsolvable_board

    # Can not win when there is no winning move
    set_grid([[ 'o', nil, nil], [nil, nil, nil], ['o', nil, nil] ])
    refute @board.solved?
    solve!
    refute @board.solved?
  end

  def test_blocks_horizontally
    refute @board.solved?

    # Will block when the opponent is about to win
    set_grid([ ['o', 'o', nil], 
               [nil, 'x', nil], 
               [nil, 'x', nil]])
    refute @board.solved?
    solve!
    refute @board.solved?
    # Placed the right letter at the right place
    assert_equal 'x', @board.get_cell(2, 0) 
  end

  def test_blocks_vertically

    set_grid([ ['x', 'o', nil],
               [nil, nil, nil],
               [nil, 'o', nil]])
    solve!
    assert_equal 'x', @board.get_cell(1, 1)
  end


  def test_forks_in_middle
    refute @board.solved?

    # Place letter in place where next turn is an automatic win
    set_grid([ ['x', 'o', 'x'], 
               [nil, nil, 'o'], 
               [nil, nil, nil]])
    refute @board.solved?
    solve!
    refute @board.solved?
    correct_cells =  @board.get_cell(1, 1) || @board.get_cell(0, 2)
    assert !!correct_cells
  end

  def test_forks_in_corner

    # 1 | 2 | x
    # 4 | o | 6
    # 7 | x | 9 <--
    set_grid([ [nil, 'o', 'x'], 
               [nil, 'o', nil], 
               [nil, 'x', nil]])
    refute @board.solved?
    solve!
    refute @board.solved?
    assert_equal 'x', @board.get_cell(2, 2)
  end

  def test_does_not_create_fork
    # 1 | 2 | o
    # 4 | x | 6
    # o | 8 | 9
    set_grid([[nil,nil,'o'],
              [nil,'x',nil],
              ['o',nil,nil]])
    solve!
    assert_nil @board.get_cell(2,2)
    assert_nil @board.get_cell(0,0)
  end

  def test_does_not_create_fork_in_the_future

    # x | 2 | 3
    # 4 | o | 6
    # 7 | 8 | o
    set_grid([ ['x',nil,nil], [nil,'o',nil], [nil,nil,'o'] ])
    solve!
    assert_nil @board.get_cell(1, 0)
    assert_nil @board.get_cell(0, 1)
    assert_nil @board.get_cell(2, 1)
    assert_nil @board.get_cell(1, 2)
  end

  def test_does_not_create_fork_in_the_far_future
    set_grid([['o', nil, nil], [nil, nil, nil], [nil, nil, nil]])
    solve!
    assert_nil @board.get_cell(0, 2)
  end


  def test_empty_corner
    set_grid([[nil,nil,nil],[nil,'o',nil],[nil,nil,nil]])
    solve!
    played_corner = @board.get_cell(0,0) || @board.get_cell(0,2) || 
                    @board.get_cell(2,0) || @board.get_cell(2,2)
    assert played_corner
  end
  
  def test_any_empty_position
    # o | x | o
    # o | x | 6
    # x | o | x
    set_grid([['o', 'x', 'o'],['o','x',nil],['x','o','x']])
    solve!
    assert_equal 'x', @board.get_cell(2, 1)
  end

  def test_raises_exception_on_full_board
    set_grid([%w(x o x), %w(o o x), %w(o x o)])
    assert_raises(RuntimeError) { solve! }
  end

  private

  def set_grid(grid)
    @board.grid = grid
  end

  def solve!
    @board.play_at(*@solver.solve, 'x')
  end
end

class MinimaxSolverTest < MiniTest::Unit::TestCase
  def setup
    @board = TicTacToe::Board.new
    @solver = TicTacToe::MinimaxStrategy.new(@board, 'x')
  end
  
  include SharedSolverTests
end

class ThreeByThreeSolverTest < MiniTest::Unit::TestCase
  def setup
    @board = TicTacToe::Board.new
    @solver = TicTacToe::ThreeByThreeStrategy.new(@board, 'x')
  end
  
  include SharedSolverTests

  def test_block_fork
    set_grid([['o', nil, nil], ['x', 'o', nil], [nil, nil, 'x']])
    solve!
    assert_equal 'x', @board.get_cell(1, 0)
  end
  
  def test_center
    # Will play in the center if its an empty @board
    assert @board.empty?
    solve!
    assert_equal 'x', @board.get_cell(@board.size/2, @board.size/2)
    assert @board.only_one?
  end
  
  def test_opposite_corner
    # 1 | 2 | o
    # 4 | x | 6
    # 7 | 8 | 9
    set_grid([[nil,nil,'o'],[nil,'x',nil],[nil,nil,nil]])
    solve!
    assert_equal 'x', @board.get_cell(0, 2)

    set_grid([['o',nil,nil],[nil,'x',nil],[nil,nil,nil]])
    solve!
    assert_equal 'x', @board.get_cell(2, 2)
  end

  def test_corners
    set_grid([['x', nil, nil], [nil, 'o', nil], [nil, nil, nil]])
    solve!
    assert_equal 'x', @board.get_cell(2,0)

    set_grid([['x', 'o', 'x'], [nil, 'o', nil], ['o', 'x', nil]])
    solve!
    assert_equal 'x', @board.get_cell(2, 2)

    # x | o | x
    # o | o | x
    #   | x | o
    set_grid([['x', 'o', 'x'], ['o', 'o', 'x'], [nil, 'x', 'o']])
    solve!
    assert_equal 'x', @board.get_cell(0, 2)
  end
end
