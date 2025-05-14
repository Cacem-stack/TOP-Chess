require_relative "./node.rb"
require_relative "./board_field.rb"
require_relative "./piece.rb"
require "pry-byebug"

class Board
  attr_accessor :field

  def initialize(field = DEFAULT_FIELD.call)
    @field = field
    @last_player = nil
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

  def choose_type
    puts "Choose a game:"
    puts "1: Player vs. Player"
    puts "2: Player vs. Cpu"

    input = gets.chomp

    until input == "1" || input == "2"
      puts "Invalid: Try again."
      input = gets.chomp
    end

    case input
    when "1"
      play
    when "2"
      play_computer
    end
  end

  def play(current = @last_player)
    current ||= "white"
    until checkmate?(current)
      turn(current)
      traverse { |node| set_moves(node) }
      current == "white" ? current = "black" : current = "white"
      if op_in_check?(current)
        puts "black team is in check" if current == "white"
        puts "white team is in check" if current == "black"
      end
    end
    current == "P1" ? current = "P2" : current = "P1"
    puts "#{current} won! The other one sucks!\n\n"
    to_s
  end

  def play_computer()
    loop do
      turn("white")
      traverse { |node| set_moves(node) }
      @last_player = "white"
      if op_in_check?("white")
        puts "black team is in check"
      end
      break if checkmate?("white")
      computer_turn("black")
      @last_player = "black"
      if op_in_check?("black")
        puts "white team is in check"
      end
      break if checkmate?("black")
    end
    to_s
    puts @last_player == "white" ? "You win!" : "Cpu wins."
  end

  def computer_turn(team)
    nodes_with_moves = []
    traverse do |node|
      if !node.piece_held.nil? && node.piece_held.moves.length > 0 && node.piece_held.team == team
        nodes_with_moves << node
      end
    end

    selected_node = nodes_with_moves[rand(nodes_with_moves.length)]
    piece = selected_node.piece_held
    selected_node_two = piece.moves[rand(piece.moves.length)]

    selected_node_two.piece_held = piece
    selected_node.piece_held = nil
    piece.node = selected_node_two
  end

  def op_in_check?(team)
    king = nil
    traverse do |node|
      if node&.piece_held.class == King && node&.piece_held.team != team
        king = node
      end
    end

    traverse do |node|
      if !node.piece_held.nil?
        return true if node.piece_held.moves.any?(king)
      end
    end

    return false
  end

  def checkmate?(team)
    king = nil
    traverse do |node|
      if node&.piece_held.class == King && node&.piece_held.team != team
        king = node.piece_held
      end
    end

    king_safe_moves = king.moves.filter do |move|
      answer = true
      traverse do |node|
        if !node.piece_held.nil?
          answer = false if node.piece_held.moves.any?(move)
        end
      end
      answer
    end

    king_threats = find_king_threats(team)
    team_pieces = find_op_team_pieces(team)

    if king_threats.length > 1 && king_safe_moves.length == 0
      #p "1"
      return true
    elsif king_safe_moves.length >= 1
      #p "2"
      return false
    else
      if team_pieces.any? { |piece| piece&.moves&.any? { |move| move == king_threats[0] } }
        #p "3"
        return false
      elsif king_safe_moves.length == 0 && op_in_check?(team)
        #p "4"
        return true
      end
    end
  end

  def find_op_team_pieces(team)
    arr = []

    traverse do |node|
      if node&.piece_held&.team != team && node&.piece_held&.team != nil
        arr << node.piece_held
      end
    end

    arr
  end

  def find_king_threats(team)
    king_node = nil
    arr = []
    traverse do |node|
      if node&.piece_held.class == King && node&.piece_held.team != team
        king_node = node
      end
    end

    traverse do |node|
      if node&.piece_held&.moves&.any?(king_node)
        arr << node
      end
    end

    arr
  end

  def game_over?()
    count = 0
    traverse do |node|
      count += 1 if node.piece_held.class == King
    end
    return true if count < 2
    return false
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

      two_d_array.each.with_index do |index_pair, index_pair_index|

        x = index_pair[0]
        y = index_pair[1]
        next if index_pair.any? {|i| i < 0 || i > 7}
        next_node = @field[x][y]
        next_piece = next_node&.piece_held
        if x < 0 || y < 0
          three_d_array[two_d_index] = []
        else
          if @field[x][y].piece_held != nil
            if !three_d_array[two_d_index].nil?
              three_d_array[two_d_index] = three_d_array[two_d_index].slice(0..index_pair_index)
            end
          end
        end
      end
    end

    return three_d_array
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

    pointer_arr.filter! do |next_node|
      next_node.piece_held&.team != node.piece_held.team
    end


    node.piece_held.moves = pointer_arr
  end

  def save_game(team)
    @last_player = team
    serialized = Marshal::dump(self)
    File.open('save.rb', 'w') do |file|
      file.write serialized
    end
    puts "Game Saved!"
    exit 0
  end


  def turn(team)
    to_s
    puts "\nSelect a piece or type \"save\" to save. #{team}'s turn:\n\n"

    player_choice = gets.chomp

    save_game(team) if player_choice == "save"

    until player_choice&.match(/[a-h][1-8]/)
      puts "Invalid format"
      player_choice = gets.chomp
    end
    x = (player_choice[0].ord - 49).chr.to_i
    y = (player_choice[1].ord - 1).chr.to_i

    selected_node = @field[x][y]

    until selected_node.piece_held.team == team && selected_node.piece_held.moves.length != 0
      puts "Invalid choice"
      player_choice = ""
      until player_choice&.match(/[a-h][1-8]/)
        puts "Invalid format" unless player_choice == ""
        player_choice = gets.chomp
        x = (player_choice[0].ord - 49).chr.to_i
        y = (player_choice[1].ord - 1).chr.to_i
        selected_node = @field[x][y]
      end
    end

    puts "\nSelect a move, #{team}:\n\n"

    next_node = gets.chomp
    until next_node&.match(/[a-h][1-8]/)
      puts "Invalid format"
      next_node = gets.chomp
    end
    x = (next_node[0].ord - 49).chr.to_i
    y = (next_node[1].ord - 1).chr.to_i

    selected_node_two = @field[x][y]

    until selected_node_two.piece_held&.team != team
      puts "Invalid choice"
      until next_node&.match(/[a-h][1-8]/)
        next_node = gets.chomp
        x = (next_node[0].ord - 49).chr.to_i
        y = (next_node[1].ord - 1).chr.to_i
        selected_node_two = @field[x][y]
      end
    end

    until selected_node_two&.piece_held.nil? && selected_node.piece_held.moves.any?(selected_node_two)
      until selected_node_two.piece_held.team == team
        puts "Invalid choice"
        until next_node&.match(/[a-h][1-8]/)
          puts "Invalid format"
          next_node = gets.chomp
          x = (next_node[0].ord - 49).chr.to_i
          y = (next_node[1].ord - 1).chr.to_i
          selected_node_two = @field[x][y]
        end
      end
    end
    selected_node_two.piece_held = selected_node.piece_held
    selected_node_two.piece_held.node = selected_node_two
    selected_node.piece_held = nil
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
