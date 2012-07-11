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
      def initialize(board, player, depth=1)
        @board, @player, @depth = board, player, depth
      end

      def maximized_move
        best_move  = nil
        best_score = nil
        best_depth = nil

        @board.any_empty_position.each do |row, column|
          board_instance = @board.clone.play_at(row, column, @player)
          # If leaf
          if board_instance.solved? || board_instance.full?
            score = score(board_instance)
            depth = @depth
          else
            move, score, depth = GameTree.new(board_instance, @player, @depth+1).minimized_move
          end

          if best_score.nil? || score > best_score || (score == best_score && depth < best_depth)
            best_score = score
            best_move  = [row, column]
            best_depth = depth
          end
        end

        [best_move, best_score, best_depth]
      end

      def minimized_move
        best_move  = nil
        best_score = nil
        best_depth = nil

        @board.any_empty_position.each do |row, column|
          board_instance = @board.clone.play_at(row, column, opponet_player)
          if board_instance.solved? || board_instance.full?
            score = score(board_instance)
            depth = @depth
          else
            move, score, depth = GameTree.new(board_instance, @player, @depth+1).maximized_move
          end

          if best_score.nil? || score < best_score || (score == best_score && depth < best_depth)
            best_score = score
            best_move  = [row, column]
            best_depth = depth
          end
        end

        [best_move, best_score, best_depth]
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

