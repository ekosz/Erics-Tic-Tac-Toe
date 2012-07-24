require 'test_helper'

class BoardTest < MiniTest::Unit::TestCase
  def setup
    @board = TicTacToe::Board.new
  end

  def test_empty
    # Board empty when created
    assert @board.empty?

    # Board not longer empty after letter placed
    @board.play_at(0,0,'o')
    refute @board.empty?
  end

  def test_full
    # Board not full when empty
    refute @board.full?

    # Board full when no cells are nil
    @board.grid = [ %w(x o x), %w(o x o), %w(x o x)]
    assert @board.full?
  end

  def test_only_one
    # False when empty
    refute @board.only_one?

    # True when one
    @board.grid = [ ['x',nil,nil], [nil,nil,nil], [nil,nil,nil] ]
    assert @board.only_one?

    # False when more than one
    @board.grid = [ ['x','x',nil], [nil,nil,nil], [nil,nil,nil] ]
    refute @board.only_one?
  end

  def test_get_cell
    # Returns nil when nothing in cell
    assert_nil @board.get_cell(0, 0)

    # Returns the right letter after they've been played
    @board.play_at(0,0,"o")
    assert_equal "o", @board.get_cell(0, 0)

    @board.play_at(1,2,"o")
    assert_equal "o", @board.get_cell(1, 2)
  end

  def test_play_at
    # Cells are proper set and override nil values
    assert_nil @board.get_cell(1,1)
    @board.play_at(1, 1, 'x')
    assert_equal 'x', @board.get_cell(1,1)
  end

  def test_can_not_override_values
    assert_nil @board.get_cell(1,1)
    @board.play_at(1, 1, 'x')
    assert_equal 'x', @board.get_cell(1,1)
    @board.play_at(1, 1, 'o')
    assert_equal 'x', @board.get_cell(1,1)
  end

  def test_solved_across
    refute @board.solved?

    @board.grid = [ %w(x x x), [nil, nil, nil], [nil, nil, nil]]
    assert @board.solved?

    @board.grid = [ [nil,nil,'x'], [nil,'o',nil], ['x','x','x'] ]
    assert @board.solved?

    @board.grid = [ %w(x o x), [nil, nil, nil], [nil, nil, nil]]
    refute @board.solved?
  end

  def test_solved_up_and_down
    refute @board.solved?

    @board.grid = [ %w(x o o), ['x', nil, nil], ['x', nil, nil]]
    assert @board.solved?

    @board.grid = [ [nil, nil, 'x'], [nil, nil, 'x'], [nil, nil, 'x']]
    assert @board.solved?

    @board.grid = [ %w(x o o), ['x', nil, nil], ['o', nil, nil]]
    refute @board.solved?
  end

  def test_won_diagonally
    refute @board.solved?

    @board.grid = [ ['x', 'o', 'x'], ['x', 'x', nil], ['o', nil, 'x']]
    assert @board.solved?

    @board.grid = [ [nil, nil, 'x'], [nil, 'x', nil], ['x', nil, nil]]
    assert @board.solved?

    @board.grid = [ [nil, nil, 'x'], [nil, 'x', nil], ['o', nil, nil]]
    refute @board.solved?
  end

end
