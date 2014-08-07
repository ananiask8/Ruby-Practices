# encoding: utf-8
# require 'rubygems'

require 'rspec'
require 'card.rb'

describe Card do
  subject(:card) {Card.new(1, :diamond)}

  describe '#value_symbol' do
    it {should respond_to :value_symbol}
    it "returns correct value symbol" do
      expect(card.value_symbol).to eq 'A'
    end
  end

  describe '#type' do
    it {should respond_to :type}
    it "returns correct type" do
      expect(card.type).to eq :diamond
    end
  end

  describe '#type_symbol' do
    it {should respond_to :symbol}
    it "returns correct type symbol" do
      expect(card.type_symbol).to eq '♦'
    end
  end
end