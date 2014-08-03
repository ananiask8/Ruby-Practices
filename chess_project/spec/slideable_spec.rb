require 'spec_helper'
require 'board'
require 'pieces'

describe Slideable do
  let(:b) { Board.new(false) }

  describe '#moves' do
    it 'adds all open spaces upto the edge in one direction' do
      p1 = Rook.new(:black, b, [0, 0])
      p2 = Pawn.new(:black, b, [1, 0])
      expect(p1.moves)
        .to eq([[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]])
    end

    it 'adds all open spaces upto the edge in two directions' do
      p2 = Rook.new(:black, b, [0, 0])
      expect(p2.moves).to eq([
        [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
        [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]
      ])
    end

    it 'adds all open spaces upto the a same piece in one direction' do
      p1 = Rook.new(:black, b, [0, 0])
      p2 = Rook.new(:black, b, [0, 3])
      p3 = Pawn.new(:black, b, [1, 0])
      expect(p1.moves).to eq([[0, 1], [0, 2]])
    end

    it 'adds open spaces upto and including enemy piece in one direction' do
      p1 = Rook.new(:black, b, [0, 0])
      p2 = Rook.new(:white, b, [0, 3])
      p3 = Pawn.new(:black, b, [1, 0])
      expect(p1.moves).to eq([[0, 1], [0, 2], [0, 3]])
    end
  end
end
