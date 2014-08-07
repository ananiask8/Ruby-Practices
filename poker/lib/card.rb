# encoding: utf-8
# require 'rubygems'

class Card
  SYMBOLS = {:spade => '♠', :heart => '♥', :diamond => '♦', :club => '♣'}
  attr_reader :value, :type, :symbol

  def initialize(value, type)
    @value = value
    @type = type
    @symbol = SYMBOLS[type.to_sym]
  end
end