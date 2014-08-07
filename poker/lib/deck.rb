require 'card.rb'

class Deck
  attr_reader :cards, :discarded

  def initialize
    @cards = []
    @discarded = []
    [:spade, :heart, :diamond, :club].each do |type|
      (1..13).each{|value| @cards << Card.new(value, type)}
    end
  end

  def deal(n_cards)
    reset if @cards.size < n_cards
    hand = []
    n_cards.times{hand << @cards.pop}
    @discarded += hand
    hand
  end

  def shuffle_deck
    @cards.sort_by!{rand}
  end

  def reset
    @cards += @discarded
    @discarded.clear
    @cards.sort_by!{rand}
  end

end