class Node

  attr_accessor :self, :index, :piece_held

  def initialize(index, piece_str = nil)
    @self = node
    @index = index
    piece_str ? @piece_held = set_piece(piece_str) : @piece_held = nil
  end

  def node
    self
  end

  def set_piece(piece_str)
    if (index[1] == 0) || (index[1] == 1)
      team = "white"
    elsif (index[1] == 6) || (index[1] == 7)
      team = "black"
    end

    case piece_str
    when "rook"
      Rook.new(team, @self)
    when "knight"
      Knight.new(team, @self)
    when "bishop"
      Bishop.new(team, @self)
    when "king"
      King.new(team, @self)
    when "queen"
      Queen.new(team, @self)
    when "pawn"
      Pawn.new(team, @self)
    end
  end


end
