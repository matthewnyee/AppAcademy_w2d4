require_relative 'piece.rb'

class Board
  attr_reader :board

  def initialize
    @board = Array.new(8) {Array.new(8)}
    seed_board
  end

  def [](pos)
    i, j = pos
    @board[i][j]  #@board or self...?
  end

  def []=(pos, piece)
    i, j = pos
    @board[i][j] = piece
  end

  def dup #have to create new Board object, not just an 8*8 array!
    new_board = Array.new(8) {Array.new(8)}
    pieces.each do |piece|
      Piece.new(piece.pos, piece.color, new_board, piece.kinged)
    end

    new_board
  end

  def pieces
    self.flatten.compact
  end

  def add_piece(pos, piece)
    self[[pos]] = piece
  end

#private these??

  def seed_board
    [1, 3, 5, 7].each do |row|
      [0, 2, 4, 6].each do |column|
        self[[row, column]] = 'x'
      end
    end
    [0, 2, 4, 6].each do |row|
      [1, 3, 5, 7].each do |column|
        self[[row, column]] = 'x'
      end
    end
    # seed_black
    # seed_white
  end

  def seed_black
    [0, 2, 4, 6].each do |n|
      Piece.new(self[[0, n]], :black,self)
      Piece.new(self[[2, n]], :black,self)
    end
    [1, 3, 5, 7].each do |n|
      Piece.new(self[[1, n]], :black,self)
    end
  end

  def seed_white
    [0, 2, 4, 6].each do |n|
      Piece.new(self[[7, n]], :white, self)
      Piece.new(self[[5, n]], :white, self)
    end
    [1, 3, 5, 7].each do |n|
      Piece.new(self[[6, n]], :white, self)
    end
  end

  def render
    output = Array.new(8) {Array.new(8)}
    (0..7).each do |row|
      (0..7).each do |column|
        if @board[row][column] == 'x'
          output[row][column] = '■'
        elsif @board[row][column].nil?
          output[row][column] = "□"
        elsif @board[row][column].color == :white
          output[row][column] = '○'
        elsif @board[row][column].color == :black
          output[row][column] = '●'
        else
          print 'whoops...'
        end
      end
    end
    #join here!
    output
  end

end


b = Board.new
# p self[0,0]
p b.render
