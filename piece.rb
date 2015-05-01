

class Piece
  attr_writer :kinged, :pos
  attr_reader :pos, :color
  attr_accessor :pos, :board

  def initialize(pos, color, board, kinged = false)
    @pos, @color, @board, @kinged = pos, color, board, kinged

    board.add_piece(pos, self)
  end

  def perform_slide(start_pos, new_pos)
    slide = pos_minus(new_pos, start_pos)
    if slide_moves.include?(slide)
      if promote?(new_pos)
        self.kinged = true
      end
      self.pos = new_pos #############
      return true
    else
      return false
    end
    raise "something went wrong with this slide"
  end

  def perform_jump(start_pos, new_pos)
    if true #@board[pos_between(start_pos, new_pos)]
      jump = pos_minus(new_pos, start_pos)
      if jump_moves.include?(jump)
        if promote?(new_pos)
          self.kinged = true
        end
        self.pos = new_pos#####################
        #@board.delete(pos_sum([jump[0] / 2, jump[1] / 2], start_pos))
        return true
      else
        return false
      end
      return "something's wrong with perform_jump"
    else
      false
    end
  end

  def pos_between(start_pos, new_pos)
    pos_sum(start_pos, pos_times(pos_minus(start_pos, new_pos), 0.5))
  end

  def slide_moves
    if self.kinged #not king
      [[1, -1], [1, 1], [-1, 1], [-1, -1]]
    else #is king
      self.color == :black ? [[1, -1], [1, 1]] : [[-1, -1], [-1, 1]]
    end
  end

  def jump_moves
    if self.kinged
      [[2, -2], [2, 2], [-2, 2], [-2, -2]]
    else
      self.color == :black ? [[2, -2], [2, 2]] : [[-2, -2], [-2, 2]]
    end
  end

  def promote?(pos)
    return true if self.pos[0] == 0 && :color == white
    return true if pos[0] == 7 && :color == black
    false
  end

  def pos_sum(a, b)
    [a[0] + b[0], a[1] + b[1]]
  end

  def pos_minus(a, b)
    [a[0] - b[0], a[1] - b[1]]
  end

  def pos_times(a, times)
    [a[0] * times, a[0] * times]
  end

  def perform_moves!(move_seq, board) #move_seq = [[start], [pos1], [pos2]]
    if move_seq.length = 2
      if perform_slide(move_seq[0], move_seq[1]) == true
        self.pos = move_seq[1] #################
      elsif perform_jump(move_seq[0], move_seq[1]) == true
        self.pos = move_seq[1]##################
      else
        raise "InvalidMoveError"
      end
    else
      (0...(move_seq.length - 1)).each do |idx|
        if perform_jump(move_seq[idx], move_seq[idx + 1]) == true
          perform_jump(move_seq[idx], move_seq[idx + 1])
          next
        else
          raise "InvalidMoveError"
        end
      end
    end
  end

  def valid_move_seq?(move_seq)
    test_board = @board.dup
    begin perform_moves!(move_seq, test_board)
    rescue
      return false
    else
      return true
    end
  end

  def perform_moves(move_seq)
    if valid_moves_seq?(move_seq)
      perform_moves!(move_seq)
    else
      raise "InvalidMoveError"
    end
  end
end
