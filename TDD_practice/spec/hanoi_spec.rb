require 'rspec'
require 'hanoi.rb'

describe Hanoi do
  subject(:hanoi) {Hanoi.new}

  describe '::new' do
    it "creates a Hanoi instance with three discs in first pile" do
      expect(hanoi.piles[0].size).to eq 3
    end

    it "has discs in first pile bigger->smaller (bottom->up)" do
      firt_pile_sorted = hanoi.piles[0].sort.reverse
      expect(hanoi.piles[0]).to eq firt_pile_sorted
    end
  end

  describe '#move' do
    context 'valid parameters' do
      context 'valid move' do
        it "moves the disc from one point to another" do
          hanoi.move(0, 1)
          expect(hanoi.piles[1]).to eq [1]
        end
      end

      context 'invalid move' do
        it "raises exception for invalid move" do
          hanoi.move(0, 1)
          expect{hanoi.move(0, 1)}.to raise_error(RuntimeError)
        end
      end
    end

    context 'invalid parameters' do
      it "raises exception for invalid parameters" do
        expect{hanoi.move(0, 15)}.to raise_error(RuntimeError)
        expect{hanoi.move('a', 'b')}.to raise_error(RuntimeError)
      end
    end
  end

  describe '#won?' do
    it "correctly indicates when the user has won the game" do
      hanoi.move(0, 2)
      hanoi.move(0, 1)
      hanoi.move(2, 1)
      hanoi.move(0, 2)
      hanoi.move(1, 0)
      hanoi.move(1, 2)
      hanoi.move(0, 2)
      expect(hanoi.won?).to be true
    end


    it "correctly indicates when the user hasn't won the game" do
      expect(hanoi.won?).to be false
    end
  end

  describe '#render' do
    it "has a method to represent the game on screen" do
      should respond_to(:render)
    end
  end
end