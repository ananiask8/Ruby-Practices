require 'spec_helper'
require 'board'
require 'pieces'

describe Stepable do
  let(:b) { Board.new(false) }

  describe '#moves' do
    it 'all moves a Pawn can make (including when taking an opponent)' do
      p = Pawn.new(:black, b, [0, 0])
      expect(p.moves).to eq([[0, 1], [1, 1]])
    end

    it 'King moves correctly' do
      p = King.new(:black, b, [5, 5])
      p2 = Rook.new(:black, b, [4, 4])
      expect(p.moves).to eq([[5, 6], [6, 5], [5, 4], [4, 5], [6, 6], [6, 4], [4, 6]])
    end

    it 'adds all open spaces upto the a same piece in one direction' do

    end

    it 'Knight moves correctly' do
      p1 = Knight.new(:black, b, [5, 5])
      p2 = Rook.new(:black, b, [4, 7])
      p3 = Rook.new(:white, b, [6, 7])
      expect(p1.moves).to eq([[7, 6], [7, 4], [3, 6], [3, 4], [6, 7], [6, 3], [4, 3]])
    end
  end
end
