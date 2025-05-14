class Board
  DEFAULT_FIELD = -> do
    return [
      [
        Node.new([0,0], "rook"),
        Node.new([0,1], "pawn"),
        Array.new(4) { |node| node = Node.new([0, node+2]) },
        Node.new([0,6], "pawn"),
        Node.new([0,7], "rook"),
      ].flatten,
      [
        Node.new([1,0], "knight"),
        Node.new([1,1], "pawn"),
        Array.new(4) { |node| node = Node.new([1, node+2]) },
        Node.new([1,6], "pawn"),
        Node.new([1,7], "knight"),
      ].flatten,
      [
        Node.new([2,0], "bishop"),
        Node.new([2,1], "pawn"),
        Array.new(4) { |node| node = Node.new([2, node+2]) },
        Node.new([2,6], "pawn"),
        Node.new([2,7], "bishop"),
      ].flatten,
      [
        Node.new([3,0], "queen"),
        Node.new([3,1], "pawn"),
        Array.new(4) { |node| node = Node.new([3, node+2]) },
        Node.new([3,6], "pawn"),
        Node.new([3,7], "queen"),
      ].flatten,
      [
        Node.new([4,0], "king"),
        Node.new([4,1], "pawn"),
        Array.new(4) { |node| node = Node.new([4, node+2]) },
        Node.new([4,6], "pawn"),
        Node.new([4,7], "king"),
      ].flatten,
      [
        Node.new([5,0], "bishop"),
        Node.new([5,1], "pawn"),
        Array.new(4) { |node| node = Node.new([5, node+2]) },
        Node.new([5,6], "pawn"),
        Node.new([5,7], "bishop"),
      ].flatten,
      [
        Node.new([6,0], "knight"),
        Node.new([6,1], "pawn"),
        Array.new(4) { |node| node = Node.new([6, node+2]) },
        Node.new([6,6], "pawn"),
        Node.new([6,7], "knight"),
      ].flatten,
      [
        Node.new([7,0], "rook"),
        Node.new([7,1], "pawn"),
        Array.new(4) { |node| node = Node.new([7, node+2]) },
        Node.new([7,6], "pawn"),
        Node.new([7,7], "rook"),
      ].flatten,
    ]
  end
end
