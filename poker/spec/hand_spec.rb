require 'rspec'
require 'hand.rb'

describe Hand do

  describe '#straight_flush?' do
    it "returns true if all cards have consecutive values and all are of the same color" do
      hand = Hand.new([
                          Card.new(1, :diamond), Card.new(5, :diamond), Card.new(3, :diamond),
                          Card.new(4, :diamond), Card.new(2, :diamond)
                        ])
      expect(hand.straight_flush?).to be true
    end
  end

  describe '#flush?' do
    it "returns true if all the cards are of the same type" do
      hand = Hand.new([
                          Card.new(1, :diamond), Card.new(5, :diamond), Card.new(3, :diamond),
                          Card.new(4, :diamond), Card.new(2, :diamond)
                        ])
      expect(hand.flush?).to be true
    end
  end

  describe '#straight?' do
      it "returns true when all the cards have consecutive A->LOW values" do
        hand = Hand.new([
                          Card.new(1, :diamond), Card.new(5, :diamond), Card.new(3, :diamond),
                          Card.new(4, :diamond), Card.new(2, :diamond)
                        ])
        expect(hand.straight?).to be true
      end

      it "returns true when all the cards have consecutive HIGH->A values" do
        hand = Hand.new([
                          Card.new(1, :diamond), Card.new(10, :diamond), Card.new(13, :diamond),
                          Card.new(11, :diamond), Card.new(12, :diamond)
                        ])
        expect(hand.straight?).to be true
      end
    end

  describe '#four_of_a_kind?' do
    it "returns true if there is a foursome of cards with same value" do
      hand = Hand.new([
            Card.new(1, :diamond), Card.new(1, :spade), Card.new(1, :heart),
            Card.new(1, :club), Card.new(5, :diamond)
          ])
      expect(hand.four_of_a_kind?).to be true
    end
  end

  describe '#full_house?' do
    it "returns true if there is a pair and three of a kind" do
      hand = Hand.new([
            Card.new(1, :diamond), Card.new(1, :spade), Card.new(1, :heart),
            Card.new(4, :diamond), Card.new(4, :spade)
          ])
      expect(hand.full_house?).to be true
    end

    it "doesn't return true if only three of a kind" do
      hand = Hand.new([
            Card.new(1, :diamond), Card.new(1, :spade), Card.new(1, :heart),
            Card.new(4, :diamond), Card.new(5, :diamond)
          ])
      expect(hand.full_house?).to be false
    end
  end

  describe '#three_of_a_kind?' do
    it "returns true if there is a threesome of cards with same value" do
      hand = Hand.new([
            Card.new(1, :diamond), Card.new(1, :spade), Card.new(1, :heart),
            Card.new(4, :diamond), Card.new(5, :diamond)
          ])
      expect(hand.three_of_a_kind?).to be true
    end
  end

  describe '#two_pair?' do
    it "returns true if there are two pairs of cards with same value" do
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

  describe '::winner' do
    it "returns hand that wins" do
      hand_a = Hand.new([
                          Card.new(1, :diamond), Card.new(5, :diamond), Card.new(3, :diamond),
                          Card.new(4, :diamond), Card.new(2, :diamond)
                        ])

      hand_b = Hand.new([
            Card.new(1, :diamond), Card.new(1, :spade), Card.new(3, :diamond),
            Card.new(4, :diamond), Card.new(5, :diamond)
          ])
      expect(Hand.winner(hand_a, hand_b)).to be hand_a
    end

    it "correctly returns a win for same rankings, based on higher card" do
      hand_a = Hand.new([
                          Card.new(1, :diamond), Card.new(5, :diamond), Card.new(3, :diamond),
                          Card.new(4, :diamond), Card.new(2, :diamond)
                        ])

      hand_b = Hand.new([
                          Card.new(6, :diamond), Card.new(5, :diamond), Card.new(3, :diamond),
                          Card.new(4, :diamond), Card.new(2, :diamond)
                        ])
      expect(Hand.winner(hand_a, hand_b)).to be hand_b
    end
  end
end