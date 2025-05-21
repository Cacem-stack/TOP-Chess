require_relative "../lib/board.rb"
require_relative "../lib/node.rb"
require_relative "../lib/piece.rb"

describe Board do
  subject(:board) { described_class.new}

  describe "#initialize" do
    subject(:board_init) { described_class.new }
    context "When called" do
      it "returns 8x8 grid" do
        field = board_init.field
        for arr in field
          expect(arr.length).to eq(8)
        end
        expect(field.length).to eq(8)
      end

      it "each element is a Node instance" do
        field = board_init.field
        for arr in field
          for node in arr
            node.class == Node
          end
        end
      end

      it "All pieces have an assigned node reference" do
        pieces = []
        field = board_init.field
        for arr in field
          for node in arr
            pieces << node.piece_held if node.piece_held
          end
        end
        expect(pieces.all? {|piece| piece.node}).to eq(true)
      end

    end
  end

  describe "#traverse" do
    subject(:board_traverse) { described_class.new }
    context "when called with block" do
      it "returns all nodes in @field" do
        arr = []
        board_traverse.traverse { |node| arr << node }
        expect(arr.length).to eq(64)
      end
    end

    context "when called without block" do
      it "returns nil" do
        expect(board_traverse.traverse).to eq(nil)
      end
    end
  end

  describe "#set_moves" do
    #subject(:node) { instance_double(Node, piece_held: )}
    context "when called on pawn" do
      subject(:move_pawn) { described_class.new }


      it "returns valid move nodes for pawn" do
        pawn = move_pawn.field[0][1].piece_held
        arr = []
        for node in pawn.moves
          arr << node.index
        end
        expect(arr).to eq([[0,2],[0,3]])
      end
    end

    context "when called on rook" do
      subject(:move_rook_pre) { described_class.new }

      before do
        field = move_rook_pre.field
        x = 0
        8.times do
          field[x][1].piece_held = nil
          x += 1
        end
      end

      subject(:move_rook) { described_class.new(move_rook_pre.field) }

      it "returns valid move nodes for rook" do
        rook = move_rook.field[0][0].piece_held

        arr = []
        for node in rook.moves
          arr << node.index
        end
        expect(arr).to eq([
          [0,1],
          [0,2],
          [0,3],
          [0,4],
          [0,5],
          [0,6]
        ])
      end
    end

    context "when called on bishop" do
      subject(:move_bishop_pre) { described_class.new }

      before do
        field = move_bishop_pre.field
        x = 0
        8.times do
          field[x][1].piece_held = nil
          x += 1
        end
      end

      subject(:move_bishop) { described_class.new(move_bishop_pre.field) }

      it "returns valid move nodes for bishop" do
        bishop = move_bishop.field[2][0].piece_held

        arr = []
        for node in bishop.moves
          arr << node.index
        end
        expect(arr.sort).to eq([
          [1,1],
          [0,2],
          [3,1],
          [4,2],
          [5,3],
          [6,4],
          [7,5]
        ].sort)
      end
    end

    context "when called on king" do
      subject(:move_king_pre) { described_class.new }

      before do
        field = move_king_pre.field
        x = 0
        8.times do
          field[x][1].piece_held = nil
          x += 1
        end
      end

      subject(:move_king) { described_class.new(move_king_pre.field) }

      it "returns valid move nodes for king" do
        king = move_king.field[4][0].piece_held

        arr = []
        for node in king.moves
          arr << node.index
        end
        expect(arr.sort).to eq([
          [3,1],
          [4,1],
          [5,1]
        ].sort)
      end
    end

    context "when called on queen" do
      subject(:move_queen_pre) { described_class.new }

      before do
        field = move_queen_pre.field
        x = 0
        8.times do
          field[x][1].piece_held = nil
          x += 1
        end
      end

      subject(:move_queen) { described_class.new(move_queen_pre.field) }

      it "returns valid move nodes for queen" do
        queen = move_queen.field[3][0].piece_held

        arr = []
        for node in queen.moves
          arr << node.index
        end
        expect(arr.sort).to eq([
          [3,1],
          [3,2],
          [3,3],
          [3,4],
          [3,5],
          [3,6],
          [2,1],
          [1,2],
          [0,3],
          [4,1],
          [5,2],
          [6,3],
          [7,4]
        ].sort)
      end
    end

    context "when called on knight" do
      subject(:move_knight_pre) { described_class.new }

      before do
        field = move_knight_pre.field
        x = 0
        8.times do
          field[x][1].piece_held = nil
          x += 1
        end
      end

      subject(:move_knight) { described_class.new(move_knight_pre.field) }

      it "returns valid move nodes for knight" do
        knight = move_knight.field[1][0].piece_held

        arr = []
        for node in knight.moves
          arr << node.index
        end
        expect(arr.sort).to eq([
          [0,2],
          [2,2],
          [3,1]
        ].sort)
      end
    end

  end

  describe "#game_over?" do
    subject(:board_over) { described_class.new }

    context "when no kings are missing" do
      it "returns false" do
        expect(board_over.game_over?).to eq(false)
      end

    end

    context "when a king is missing" do
      before do
        white_king_node = board_over.field[4][0]
        white_king_node.piece_held = nil
      end
      it "returns true" do
        expect(board_over.game_over?).to eq(true)
      end
    end
  end

  describe "#turn" do
    context "When P1 has chosen legal move" do
      subject(:board_p1) { described_class.new }

      before do
        allow(board_p1).to receive(:gets).and_return("c2", "c3")
        allow(board_p1).to receive(:to_s)
      end

      it "Moves piece to selected node" do
        field = board_p1.field

        expect(board_p1).to receive(:puts).twice
        board_p1.turn("white")
        expect(field[2][1].piece_held).to eq(nil)
        expect(field[2][2].piece_held.class).to eq(Pawn)
      end
    end

    context "When P2 has chosen legal move" do
      subject(:board_p2) { described_class.new }

      before do
        allow(board_p2).to receive(:gets).and_return("c7", "c6")
        allow(board_p2).to receive(:to_s)
      end

      it "Moves piece to selected node" do
        field = board_p2.field

        expect(board_p2).to receive(:puts).twice
        board_p2.turn("black")
        expect(field[2][6].piece_held).to eq(nil)
        expect(field[2][5].piece_held.class).to eq(Pawn)
      end
    end

  end

  describe "#op_in_check?" do
    context "if a king is not in check" do
      subject(:board_check) { described_class.new }
      it "returns false" do
        expect(board_check.op_in_check?("white")).to eq(false)
      end
    end

    context "if a king is in check" do
      subject(:board_check) { described_class.new }

      it "returns true" do
        field = board_check.field
        field[4][6].piece_held = nil
        field[4][1].piece_held = Rook.new("white", field[4][1])


        board_check.traverse { |node| board_check.set_moves(node) }
        expect(board_check.op_in_check?("white")).to eq(true)
      end
    end
  end

  describe "#checkmate?" do
    context "if king is in not checkmate" do

      subject(:board_checkmate) { described_class.new() }

      it "returns false" do
        field = board_checkmate.field

        field.each_with_index do |arr, x|
          arr.each_with_index do |elem, y|
            field[x][y] = Node.new([x, y])
          end
        end

        field[1][7].piece_held = Rook.new("black", field[1][7])
        field[4][5].piece_held = King.new("black", field[4][5])
        field[6][5].piece_held = Knight.new("white", field[6][5])
        field[1][2].piece_held = Queen.new("white", field[1][2])
        field[3][2].piece_held = Rook.new("white", field[3][2])
        field[5][2].piece_held = Rook.new("white", field[5][2])
        field[6][2].piece_held = Bishop.new("white", field[6][2])
        field[3][0].piece_held = King.new("white", field[3][0])

        board_checkmate.traverse { |node| board_checkmate.set_moves(node) }
        expect(board_checkmate.checkmate?("white")).to eq(false)
      end
    end

    context "if king is in checkmate" do
      subject(:board_checkmate_win) { described_class.new }

      it "returns true" do
        field = board_checkmate_win.field

        field.each_with_index do |arr, x|
          arr.each_with_index do |elem, y|
            field[x][y] = Node.new([x, y])
          end
        end

        field[4][5].piece_held = King.new("black", field[4][5])
        field[6][5].piece_held = Knight.new("white", field[6][5])
        field[1][2].piece_held = Queen.new("white", field[1][2])
        field[3][2].piece_held = Rook.new("white", field[3][2])
        field[5][2].piece_held = Rook.new("white", field[5][2])
        field[6][2].piece_held = Bishop.new("white", field[6][2])
        field[3][0].piece_held = King.new("white", field[3][0])

        board_checkmate_win.traverse { |node| board_checkmate_win.set_moves(node) }
        expect(board_checkmate_win.checkmate?("white")).to eq(true)
      end
    end
  end

  #describe "Additional Pawn Testing:" do
  #  context "When opponent is within pawns' wrath" do
  #    subject(:pawn_board) { described_class.new }
  #    xit "Allows pawn to eat opponent" do
  #      field = pawn_board.field

  #      field.each_with_index do |arr, x|
  #        arr.each_with_index do |elem, y|
  #          field[x][y] = Node.new([x, y])
  #        end
  #      end

  #      #5,3 6,3W 6,4B
  #      field[5][3].piece_held = Pawn.new("white", field[5][3])
  #      field[6][3].piece_held = Pawn.new("white", field[6][3])
  #      field[6][4].piece_held = Pawn.new("black", field[6][4])

  #      pawn1 = field[5][3].piece_held
  #      pawn2 = field[6][3].piece_held
  #      pawn3 = field[6][4].piece_held

  #      pawn_board.traverse { |node| pawn_board.set_moves(node) }
  #      pawn_board.to_s
  #      print "\nPawn one: #{pawn1.moves.map(&:index)}\n"
  #      print "\nPawn two: #{pawn2.moves.map(&:index)}\n"
  #      print "\nPawn three: #{pawn3.moves.map(&:index)}\n"

  #    end
  #  end
  #end

  #describe "-DEBUG" do
  #  subject(:game_put) { described_class.new }
  #  xit do
  #    #game_put.to_s
  #    #game_put.turn("white")
  #  end
  #end

end
