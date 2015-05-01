require_relative 'piece.rb'
require_relative 'board.rb'

class Game
  def initialize
    @board = Board.new
  end

  def play
    gets
  end
end
