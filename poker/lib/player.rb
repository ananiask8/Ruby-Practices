require 'hand.rb'

class Player

  attr_reader :bid, :name, :pot

  class << self
    @@count = 0
  end

  def initialize(pot)
    @pot = pot
    @@count += 1
    @name = "Player ##{@@count}"
  end

  def new_game(hand, minimum_bid)
    @active = true
    @hand = hand
    @bid = minimum_bid
    @pot -= @bid
    raise "Insufficient founds" if @pot < 0
  end

  def hand_size
    @hand.cards.size
  end

  def add_card(card)
    @hand.cards << card
  end

  def add_to_pot(pot)
    @pot += pot
  end

  def play
    show_hand
    discard
    action
  end

  def action
    input = read_input
    case input
    when "f"
      @active = false
    when "r"
      raise_bid
    end

  end

  def read_input
    gets.chomp
  end

  def discard
    input = read_input.split(" ").map(&:to_i)[0...3]
    @hand.cards = @hand.cards.reject.with_index{|card, index| input.include?(index + 1)}
  end

  def raise_bid
    input = read_input.to_i
    if input > @bid
      @pot -= (input - @bid)
      @bid = input
    end
  end

  def playing?
    @active
  end

  def show_hand
    hand_values = @hand.cards.map{|card| "#{card.value_symbol}#{card.type_symbol}"}.join(" ")
    puts "#{@name}: #{hand_values}"
  end
end