class Piece

  attr_accessor  :team, :node, :moves

  def initialize(team, node, moves = [0,0])
    @team = team
    @node = node
    @moves = moves
    @team == "white" ? @symbol = :+ : @symbol = :-
  end


  def sanitize_2d_move_array
  end

  def sanitize_3d_array
  end
end

class Pawn < Piece

  def initialize(team, node)
    super
  end

  def get_moves
    x = @node.index[0]
    y = @node.index[1]

    if !starting_position?
      [
        [x, y.public_send(@symbol, 1)]
      ]
    elsif starting_position?
      [
        [x, y.public_send(@symbol, 1), ],
        [x, y.public_send(@symbol, 2), ]
      ]
    end
  end

  def starting_position?
    case @team
    when "white"
      starting_row = 1
    when "black"
      starting_row = 6
    end

    return true if @node.index[1] == starting_row
    return false
  end


end

class King < Piece
  def get_moves
    x = @node.index[0]
    y = @node.index[1]
    [
      [ x + 1, y ],
      [ x - 1, y ],
      [ x, y + 1],
      [ x, y - 1],
      [ x + 1, y + 1 ],
      [ x - 1, y + 1 ],
      [ x + 1, y - 1],
      [ x - 1, y - 1]
    ]
  end
end

class Queen < Piece
  def get_moves
    x = @node.index[0]
    y = @node.index[1]
    arr = Array.new(8) {[]}

    arr.each_with_index do |e, i|
      a = x
      b = y
      case i
      when 0
        7.times do
        arr[0] << [(a + 1), (b + 1)]
        a += 1
        b += 1
        end
      when 1
        7.times do
        arr[1] << [(a - 1), (b + 1)]
        a -= 1
        b += 1
        end
      when 2
        7.times do
        arr[2] << [(a + 1), (b - 1)]
        a += 1
        b -= 1
        end
      when 3
        7.times do
        arr[3] << [(a - 1), (b - 1)]
        a -= 1
        b -= 1
        end
      when 4
        7.times do
        arr[4] << [a, (b + 1)]
        b += 1
        end
      when 5
        7.times do
        arr[5] << [a, (b - 1)]
        b -= 1
        end
      when 6
        7.times do
        arr[6] << [(a + 1), b]
        a += 1
        end
      when 7
        7.times do
        arr[0] << [(a - 1), b]
        a -= 1
        end
      end
    end

    return arr
  end
end

class Bishop < Piece
  def get_moves
    x = @node.index[0]
    y = @node.index[1]
    arr = Array.new(4) {[]}

    arr.each_with_index do |e, i|
      a = x
      b = y
      case i
      when 0
        7.times do
        arr[0] << [(a + 1), (b + 1)]
        a += 1
        b += 1
        end
      when 1
        7.times do
        arr[1] << [(a - 1), (b + 1)]
        a -= 1
        b += 1
        end
      when 2
        7.times do
        arr[2] << [(a + 1), (b - 1)]
        a += 1
        b -= 1
        end
      when 3
        7.times do
        arr[3] << [(a - 1), (b - 1)]
        a -= 1
        b -= 1
        end
      end
    end

    return arr
  end
end

class Rook < Piece
  def get_moves
    x = @node.index[0]
    y = @node.index[1]
    arr = Array.new(4) {[]}

    arr.each_with_index do |e, i|
      a = x
      b = y
      case i
      when 0
        7.times do
        arr[0] << [a, (b + 1)]
        b += 1
        end
      when 1
        7.times do
        arr[1] << [a, (b - 1)]
        b -= 1
        end
      when 2
        7.times do
        arr[2] << [(a + 1), b]
        a += 1
        end
      when 3
        7.times do
        arr[3] << [(a - 1), b]
        a -= 1
        end
      end
    end

    return arr
  end
end

class Knight < Piece
  def get_moves
    x = @node.index[0]
    y = @node.index[1]
    [
      [x + 1, y + 2],
      [x + 1, y - 2],
      [x - 1, y + 2],
      [x - 1, y - 2],
      [x + 2, y + 1],
      [x + 2, y - 1],
      [x - 2, y + 1],
      [x - 2, y - 1]
    ]
  end
end

