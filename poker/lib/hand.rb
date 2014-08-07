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

  class << self
    def winner(hand_a, hand_b)
      if RANKINGS.find_index(ranking(hand_a)) == RANKINGS.find_index(ranking(hand_b))
        return VALUES[hand_a.high_card].last < VALUES[hand_b.high_card].last ? hand_a : hand_b
        #used last because of A (to take 14)
      end

      RANKINGS.find_index(ranking(hand_a)) < RANKINGS.find_index(ranking(hand_b)) ? hand_a : hand_b
    end

    def ranking(hand)
      RANKINGS.find{|ranking| hand.send((ranking.to_s + "?").to_sym)}
    end
  end

  def initialize(new_hand)
    @hand = new_hand
  end

  def high_card
    return "A" if @hand.map(&:value_symbol).include? "A"
    @hand.max{|card_a, card_b| VALUES[card_a.value_symbol] <=> VALUES[card_b.value_symbol]}.value_symbol
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

  def full_house?
    one_pair? && three_of_a_kind?
  end

  def straight?
    copy_hand = @hand.select{|card| card.value_symbol != "A"}
    sorted_copy = copy_hand.sort{|card_a, card_b| VALUES[card_a.value_symbol] <=> VALUES[card_b.value_symbol]}

    straight_without_a = sorted_copy.select.with_index do |card, i|
      VALUES[card.value_symbol] == VALUES[sorted_copy.first.value_symbol].map{|value| value + i}
    end.size == sorted_copy.size

    straight_without_a && (sorted_copy.size == 5 || sorted_copy.first.value_symbol == "2" || sorted_copy.last.value_symbol == "K")
  end

  def flush?
    x_type = @hand.sample.type
    @hand.all?{|card| card.type == x_type}
  end

  def straight_flush?
    straight? && flush?
  end

end