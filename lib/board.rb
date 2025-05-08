require_relative "./node.rb"
require_relative "./board_field.rb"

class Board
  attr_accessor :field

  def initialize(field = DEFAULT_FIELD.call)
    @field = field
    traverse { |node| set_moves(node) }
  end

  def traverse()
    return nil if !block_given?
    for arr in @field
      for node in arr
        yield node
      end
    end
  end

  def sanitize_2d_move_array(two_d_array)
    index_one = two_d_array[0]
    if @field[index_one[0]][index_one[1]].piece_held
      return []
    end
    return two_d_array
  end

  def sanitize_3d_move_array(three_d_array)
    three_d_array.each.with_index do |two_d_array, two_d_index|
      tracker = three_d_array[two_d_index]
      two_d_array.each.with_index do |array, arr_index|
        if @field[array[0]] && @field[array[0]][array[1]]&.piece_held
          three_d_array[two_d_index] = two_d_array.slice(0, arr_index)
        end
      end
    end
  end

  def set_moves(node)
    return nil if node.piece_held == nil
    index = node.index
    pointer_arr = []
    moves = node.piece_held.get_moves
    is_2d_array = -> (iterable) { iterable.any? {|e| e.class == Array }}

    sanitize_2d_move_array(moves) if node.piece_held.class == Pawn

    if moves.any? { |arr| arr.any? { |sub| sub.class == Array } }
      sanitize_3d_move_array(moves)
    end

    for next_index in moves
      case is_2d_array.call(next_index)
      when true
        for next_sub_index in next_index
          next if next_sub_index.any? {|i| i < 0 || i > 7}
          x = next_sub_index[0]
          y = next_sub_index[1]
          pointer_arr << @field[x][y]
        end
      else
        next if next_index.any? {|i| i < 0 || i > 7} || next_index[0].nil?
        x = next_index[0]
        y = next_index[1]
        pointer_arr << @field[x][y]
      end

      if node.piece_held.class == Pawn
        case "#{node.piece_held.team}"
        when "white"
          eater_moves = [
            [node.index[0] + 1, node.index[1] + 1],
            [node.index[0] - 1, node.index[1] + 1]
          ]

          for move in eater_moves
            if @field[move[0]]
              next_node = @field[move[0]][move[1]]
              if next_node&.piece_held && next_node&.piece_held.team != node.piece_held.team
                pointer_arr << @field[move[0]][move[1]]
              end
            end
          end

        when "black"
          eater_moves = [
            [node.index[0] + 1, node.index[1] - 1],
            [node.index[0] - 1, node.index[1] - 1]
          ]

          for move in eater_moves
            if @field[move[0]]
              next_node = @field[move[0]][move[1]]
              if next_node&.piece_held && next_node&.piece_held.team != node.piece_held.team
                pointer_arr << @field[move[0]][move[1]]
              end
            end
          end

        end
      end
    end
    #p node.piece_held.class
    #p pointer_arr.length
    #sleep 0.2
    node.piece_held.moves = pointer_arr
  end

  def game_over?()
    count = 0
    traverse do |node|
      count += 1 if node.piece_held.class == King
    end
    return true if count < 2
    return false
  end

  def to_s
    x = 0
    y = 7
    while y >= 0
      while x <= 7
        spacer = 1
        print "#{Array.new(8) {" - - - - #{Array.new(spacer) {" "}.join("")}"}.join('')}\n" if y == 7 and x == 0

        node = @field[x][y]
        piece = node.piece_held
        is_white = -> { piece.team == "white"}
        chess_index = -> { "#{(node.index[0].to_s.ord + 49).chr}#{(node.index[1].to_s.ord + 1).chr}"}
        space = Array.new(spacer) {" "}.join
        case "#{piece.class}"
        when "King"
          print is_white.call ? "| #{chess_index.call}: \u2654 |"  + space : "| #{chess_index.call}: \u265a |"  + space
        when "Queen"
          print is_white.call ? "| #{chess_index.call}: \u2655 |"  + space : "| #{chess_index.call}: \u265b |"  + space
        when "Rook"
          print is_white.call ? "| #{chess_index.call}: \u2656 |"  + space : "| #{chess_index.call}: \u265c |"  + space
        when "Bishop"
          print is_white.call ? "| #{chess_index.call}: \u2657 |"  + space : "| #{chess_index.call}: \u265d |"  + space
        when "Knight"
          print is_white.call ? "| #{chess_index.call}: \u2658 |"  + space : "| #{chess_index.call}: \u265e |"  + space
        when "Pawn"
          print is_white.call ? "| #{chess_index.call}: \u2659 |"  + space : "| #{chess_index.call}: \u265f |"  + space
        else
          print "| #{chess_index.call}:   |" + space
        end
        x += 1
      end
      print "\n"
      print "#{Array.new(8) {" - - - - #{Array.new(spacer) {" "}.join("")}"}.join('')}"
      spacer.times { print "\n"}
      print "#{Array.new(8) {" - - - - #{Array.new(spacer) {" "}.join("")}"}.join('')}" if y != 0 and x != 7
      print "\n"
      y -= 1
      x = 0
    end
  end

end
