module TicTacToe
  # This implements the Minimax algorithum with AlphaBeta Prunning
  # http://en.wikipedia.org/wiki/Minimax
  # http://en.wikipedia.org/wiki/Alpha-beta_pruning
  class MinimaxStrategy

    attr_reader :board # Avoid getters, setters and properties

    def initialize(board, letter)
      @board, @letter = board, letter
    end

    def solve
      Minimax.new(@board, @letter).best_move
    end
  end

  # The game tree needs a evaluator for generating rankings,
  # an initial game state,
  # and a player
  #
  # This class uses 5 instance variables: @evaluator, @state, 
  # @depth, @alpha, @beta. Should be < 3
  #
  # This class has 63 lines. Should be <= 50
  class Minimax

    MAXDEPTH = 5
    PositiveInfinity = +1.0/0.0 
    NegativeInfinity = -1.0/0.0 

    # has 5 parameters (LongParameterList)
    def initialize(board, player)
      @start_board = board
      @player = player
    end

    def best_move
      @start_board.any_empty_position.max_by do |column, row| 
        score(@start_board.clone.play_at(column, row, @player), next_turn(@player))
      end
    end

    private 

    def score(board, whos_turn, depth=1, 
              alpha=NegativeInfinity, beta=PositiveInfinity)

      if board.full? || board.solved?
        return  1.0 / depth if board.winner == @player
        return -1.0         if board.solved?
        return  0
      end

      if whos_turn == @player
        board.any_empty_position.each do |column, row|
          alpha = [alpha, 
                   score(board.clone.play_at(column, row, whos_turn), 
                         next_turn(whos_turn), depth+1, alpha, beta)
                  ].max
          break if beta <= alpha || depth >= MAXDEPTH
        end
        return alpha
      end

      board.any_empty_position.each do |column, row|
        beta = [beta, 
                 score(board.clone.play_at(column, row, whos_turn), 
                       next_turn(whos_turn), depth+1, alpha, beta)
                ].min
        break if alpha >= beta || depth >= MAXDEPTH
      end
      beta
    end

    def next_turn(player)
      case player
      when X then O
      when O then X
      end
    end
  end
end

