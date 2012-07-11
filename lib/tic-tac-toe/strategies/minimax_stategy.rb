module TicTacToe
  class MinimaxStrategy

    attr_reader :board

    def initialize(board, letter)
      @board, @letter = board, letter
    end

    def solve!
      move, score, depth = GameTree.new(@board, @letter).maximized_move
      @board.play_at(move[0], move[1], @letter)
    end

    class GameTree
      PositiveInfinity = +1.0/0.0 
      NegativeInfinity = -1.0/0.0 

      attr_reader :alpha, :beta

      def initialize(board, player, depth=1, alpha=NegativeInfinity, beta=PositiveInfinity)
        @board, @player, @depth = board, player, depth
        @alpha, @beta = alpha, beta
      end

      def maximized_move
        best_move  = nil
        best_depth = PositiveInfinity

        @board.any_empty_position.each do |row, column|
          board_instance = @board.clone.play_at(row, column, @player)
          # If leaf
          if board_instance.solved? || board_instance.full?
            score = score(board_instance)
            depth = @depth
          else
            move, score, depth = GameTree.new(board_instance, @player, @depth+1, @alpha, @beta).minimized_move
          end

          if score > @alpha || (score == @alpha && depth < best_depth)
            @alpha = score
            best_move  = [row, column]
            best_depth = depth
          end

          break if @alpha >= @beta

        end

        [best_move, @alpha, best_depth]
      end

      def minimized_move
        best_move  = nil
        best_depth = PositiveInfinity

        @board.any_empty_position.each do |row, column|
          board_instance = @board.clone.play_at(row, column, opponet_player)
          if board_instance.solved? || board_instance.full?
            score = score(board_instance)
            depth = @depth
          else
            move, score, depth = GameTree.new(board_instance, @player, @depth+1, @alpha, @beta).maximized_move
          end

          if score < @beta || (score == @beta && depth < best_depth)
            @beta = score
            best_move  = [row, column]
            best_depth = depth
          end

          break if @beta <= @alpha

        end

        [best_move, @beta, best_depth]
      end

      def score(board)
        return  1 if board.winner == @player
        return -1 if board.solved?
        0
      end

      def opponet_player
        case @player
        when X then O
        when O then X
        end
      end

    end
  end
end

