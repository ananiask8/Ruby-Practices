# encoding: utf-8
# require 'rubygems'
require 'rspec'
require 'player.rb'

describe Player do
  let(:player) {Player.new(20)}

  before(:each) do
    player.new_game(Hand.new([
                      Card.new(1, :diamond), Card.new(5, :diamond), Card.new(3, :diamond),
                      Card.new(4, :diamond), Card.new(2, :diamond)
                    ]), 10)
  end

  describe '#new_game' do

    it "gets a hand" do
      expect(player.hand_size).not_to be nil
    end

    it "sets the bid to the minimum" do
      expect(player.bid).to eq 10
    end
  end

  describe '#play' do
    it 'calls #show_hand' do
      expect(player).to receive(:show_hand)
      player.play
    end

    it 'calls #discard' do
      allow(player).to receive(:show_hand)
      expect(player).to receive(:discard)
      player.play
    end

    it 'calls #action' do
      allow(player).to receive(:show_hand)
      allow(player).to receive(:discard)
      expect(player).to receive(:action)
      player.play
    end
  end

  describe '#show_hand' do
    it "prints the values of the hand of the player" do
      STDOUT.should_receive(:puts).with('Player #6: A♦ 5♦ 3♦ 4♦ 2♦')
      player.show_hand
    end
  end

  describe '#discard' do
    it "eliminates the cards chosen by user" do
      allow(player).to receive(:read_input).and_return("1 2 5")
      player.discard
      expect(player.hand_size).to eq 2
    end
  end

  describe '#add_card' do #writing only
    it "completes the hand if payer has less than 5" do
      allow(player).to receive(:read_input).and_return("1")
      player.discard
      player.add_card(Card.new(1, :diamond))
      expect(player.hand_size).to eq 5
    end
  end

  describe '#action' do
    context 'if the user folds' do
      it "sets up 'playing?' marker to false" do
        allow(player).to receive(:read_input).and_return("f")
        player.action
        expect(player.playing?).to be false
      end
    end

    context 'if the user sees' do
      it "doesn't set up 'playing?' to false" do
        allow(player).to receive(:read_input).and_return("s")
        player.action
        expect(player.playing?).to be true
      end

      it "doesn't call the method #raise_bid" do
        allow(player).to receive(:read_input).and_return("s")
        player.action
        expect(player).not_to receive(:raise_bid)
      end
    end

    context 'if the user raises his bid' do
      it "calls method #raise_bid" do
        allow(player).to receive(:read_input).and_return("r")
        expect(player).to receive(:raise_bid)
        player.action
      end
    end

  end

  describe '#raise_bid' do
    it "allows the user to raise his bet" do
      allow(player).to receive(:read_input).and_return("15")
      player.raise_bid
      expect(player.bid).to be 15
    end

    it "disallows the user to lower his bid" do
      allow(player).to receive(:read_input).and_return("5")
      player.raise_bid
      expect(player.bid).to be 10
    end
  end

end