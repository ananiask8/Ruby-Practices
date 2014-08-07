require 'rspec'
require 'game.rb'

describe Game do {}
  let(:player1) {Player.new(20)}
  let(:player2) {Player.new(15)}
  let(:player3) {Player.new(5)}

  describe '#run' do
    subject(:game) {Game.new(10, player1, player2, player3)}

    it 'calls #capable_players' do
      allow(game).to receive(:game_over?).and_return false
      expect(game).to receive(:capable_players).and_return [player1, player3]
      allow(game).to receive(:game_over?).and_return true
      game.run
    end

    it "keeps track of the amount of money in the pot"

    it "keeps track of whose turn it is"
  end

  describe '#capable_players' do
    subject(:game) {Game.new(18, player1, player2, player3)}

    it "returns only the players that can bet the minimum in the game" do
      expect(game.capable_players).to eq [player1]
    end
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