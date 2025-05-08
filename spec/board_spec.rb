require_relative "../lib/board.rb"
require_relative "../lib/node.rb"
require_relative "../lib/piece.rb"

describe Board do

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
        #p pieces[0]
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
    subject(:board_moves) { described_class.new }
    #subject(:node) { instance_double(Node, piece_held: )}
    context "when called" do


      it "returns valid move nodes for pawn" do
        pawn = board_moves.field[0][1].piece_held
        arr = []
        for node in pawn.moves
          arr << node.index
        end
        expect(arr).to eq([[0,2],[0,3]])
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
        white_king_node = board_over.field[3][0]
        white_king_node.piece_held = nil
      end
      it "returns true" do
        expect(board_over.game_over?).to eq(true)
      end
    end
  end

  describe "-DEBUG" do
    subject(:game_put) { described_class.new }
    xit do
      game_put.to_s
    end
  end


end
