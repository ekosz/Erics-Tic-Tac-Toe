module TicTacToe

  module Strategy
    # This implements the Minimax algorithum with AlphaBeta Prunning
    # http://en.wikipedia.org/wiki/Minimax
    # http://en.wikipedia.org/wiki/Alpha-beta_pruning
    class MinimaxStrategy

      attr_reader :board

      def initialize(board, letter)
        @board, @letter = board, letter
      end

      def solve
        raise "Can not solve a full board" if @board.full?
        Minimax.new(@board, @letter).best_move
      end
    end

    # The game tree needs a evaluator for generating rankings,
    # an initial game state,
    # and a player
    class Minimax

      MAXDEPTH = 6
      PositiveInfinity = +1.0/0.0 
      NegativeInfinity = -1.0/0.0 

      def initialize(board, player)
        @start_board = board
        @player = player
      end

      def best_move
        @start_board.empty_positions.max_by do |column, row| 
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
          board.empty_positions.each do |column, row|
            alpha = [
              alpha, 
              next_score(board, column, row, whos_turn, depth, alpha, beta)
            ].max
            break if beta <= alpha || depth >= MAXDEPTH
          end
          return alpha
        end

        board.empty_positions.each do |column, row|
          beta = [
            beta, 
            next_score(board, column, row, whos_turn, depth, alpha, beta)
          ].min
          break if alpha >= beta || depth >= MAXDEPTH
        end
        beta
      end

      def next_score(board, column, row, whos_turn, depth, alpha, beta)
        score( board.clone.play_at(column, row, whos_turn),
              next_turn(whos_turn),
              depth+1, alpha, beta
             )
      end

      def next_turn(player)
        case player
        when X then O
        when O then X
        end
      end
    end
  end
end

