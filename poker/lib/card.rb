# encoding: utf-8
# require 'rubygems'

class Card
  TYPES = {:spade => '♠', :heart => '♥', :diamond => '♦', :club => '♣'}
  VALUES_SYMBOLS = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
  attr_reader :value_symbol, :type, :type_symbol

  def initialize(value, type)
    @type = type
    @type_symbol = TYPES[type.to_sym]
    @value_symbol = VALUES_SYMBOLS[value - 1]
  end
end