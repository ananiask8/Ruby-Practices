require 'rspec'
require 'game.rb'

describe Game do {}
  let(:player1) {Player.new(20)}
  let(:player2) {Player.new(15)}
  let(:player3) {Player.new(5)}
  # subject(:game) {Game.new(10)}

  describe '#run' do
    it "deals the players with 5 cards" #do
      # expect(players).to receive(new_hand)

    it "keeps track of the amount of money in the pot"

    it "keeps track of whose turn it is"
  end

  describe '#game_over?' do
    subject(:game) {Game.new(10, player1, player3)}

    it "detects when one player has all the money" do
      expect(game.game_over?).to be true
    end
  end

  describe '#winner' do
    subject(:game) {Game.new(10, player1, player3)}

    it "detects player with highest pot" do
      expect(game.winner).to be player1
    end
  end
end