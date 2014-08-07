require 'set'
require 'card.rb'

class Hand

  VALUES = {"A" => [1, 14], "2" => [2], "3" => [3], "4" => [4], "5" => [5],
          "6" => [6], "7" => [7], "8" => [8], "9" => [9], "10" => [10],
          "J" => [11], "Q" => [12], "K" => [13]
        }

  RANKINGS = [:straight_flush, :four_of_a_kind, :full_house, :flush, :straight,
            :three_of_a_kind, :two_pair, :one_pair, :high_card
          ]

  def initialize(new_hand)
    @hand = new_hand
  end

  def high_card
    @hand.max{|card_a, card_b| VALUES[card_a] <=> VALUES[card_b]}.value_symbol
  end

  def occurrences(n)
    pairs_symbols = Set.new
    values = @hand.map{|card| card.value_symbol}
    values.each{|value| pairs_symbols << value if values.count(value) == n}
    pairs_symbols.to_a
  end

  def one_pair?
    occurrences(2).size == 1
  end

  def two_pair?
    occurrences(2).size == 2
  end

  def three_of_a_kind?
    occurrences(3).size > 0
  end

  def four_of_a_kind?
    occurrences(4).size > 0
  end
end