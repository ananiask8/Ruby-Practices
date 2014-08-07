# encoding: utf-8
# require 'rubygems'

require 'rspec'
require 'card.rb'

describe Card do
  subject(:card) {Card.new(3, :diamond)}

  describe '#value' do
    it { should respond_to :value}
    it "returns correct value" do
      expect(card.value).to eq 3
    end
  end

  describe '#type' do
    it {should respond_to :type}
    it "returns correct type" do
      expect(card.type).to eq :diamond
    end
  end

  describe '#symbol' do
    it {should respond_to :symbol}
    it "returns correct symbol" do
      expect(card.symbol).to eq '♦'
    end
  end
end