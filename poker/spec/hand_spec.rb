require 'rspec'
require 'hand.rb'

describe Hand do
  describe '#straight_flush?' do
    # it "accurately detects a straight flush" do
    #   double("")
    # end
  end

  describe '#four_of_a_kind?' do

  end

  describe '#full_house?' do

  end

  describe '#flush?' do

  end

  describe '#straight?' do

  end

  describe '#three_of_a_kind?' do
    it "returns true if there is a pair of cards with same value" do
      hand = Hand.new([
            Card.new(1, :diamond), Card.new(1, :spade), Card.new(1, :heart),
            Card.new(4, :diamond), Card.new(5, :diamond)
          ])
      expect(hand.three_of_a_kind?).to be true
    end
  end

  describe '#two_pair?' do
    it "returns true if there is a pair of cards with same value" do
      hand = Hand.new([
            Card.new(1, :diamond), Card.new(1, :spade), Card.new(3, :diamond),
            Card.new(4, :diamond), Card.new(4, :spade)
          ])
      expect(hand.two_pair?).to be true
    end
  end

  describe '#one_pair?' do
    it "returns true if there is a pair of cards with same value" do
      hand = Hand.new([
            Card.new(1, :diamond), Card.new(1, :spade), Card.new(3, :diamond),
            Card.new(4, :diamond), Card.new(5, :diamond)
          ])
      expect(hand.one_pair?).to be true
    end
  end

  describe '#high_card' do
    it "returns highest card on hand" do
      hand = Hand.new([
            Card.new(1, :diamond), Card.new(2, :diamond), Card.new(3, :diamond),
            Card.new(4, :diamond), Card.new(5, :diamond)
          ])
      expect(hand.high_card).to eq "A"
    end
  end

  describe '#best_hand' do

  end
end