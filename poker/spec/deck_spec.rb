require 'rspec'
require 'deck.rb'

describe Deck do
  subject(:deck) {Deck.new}

  describe '::new' do
    it "creates a deck with 52 cards" do
      expect(deck.cards.size).to eq 52
    end

    it "has 12 cards of each type" do
      expect(deck.cards.select{|card| card.type == :spade}.size).to eq 13
      expect(deck.cards.select{|card| card.type == :heart}.size).to eq 13
      expect(deck.cards.select{|card| card.type == :diamond}.size).to eq 13
      expect(deck.cards.select{|card| card.type == :club}.size).to eq 13
    end

    it "has 4 cards of each value" do
      expect(deck.cards.select{|card| card.value_symbol == "A"}.size).to eq 4
      expect(deck.cards.select{|card| card.value_symbol == "2"}.size).to eq 4
      expect(deck.cards.select{|card| card.value_symbol == "Q"}.size).to eq 4
    end
  end

  describe '#reset' do
    it "shuffles all 42 cards" do
      deck.deal(5)
      deck.reset
      expect(deck.cards.size).to eq 52
      expect(deck.discarded.size).to eq 0
    end
  end

  describe '#deal' do
    it "deals n_cards from the deck at random" do
      expect(deck.deal(3).size).to eq 3
    end

    it "disables for further use (until reset) the cards used" do
      deck.deal(5)
      expect(deck.cards.size).to eq 47
      expect(deck.discarded.size).to eq 5
    end
  end
end