require 'rspec'
require 'card.rb'

describe Card do
  subject(:card) {Card.new(3, :diamond)}

  describe '#value' do
    it { should respond_to :value}
    it "returns correct value" {expect(card.value).to eq 3}
  end

  describe '#type' do
    it {should respond_to :type}
    it "returns correct type" {expect(card.type).to eq :diamond}
  end
end