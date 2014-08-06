require 'rspec'
require 'array_ex.rb'

describe Array do

  describe "#my_uniq" do
    subject(:arr) {[1, 2, 1, 3, 3]}

    it "removes duplicate elements" do
      expect(arr.my_uniq).to eq([1, 2, 3])
    end
  end

  describe "#two_sum" do
    subject(:arr) {[-1, 0, 2, -2, 1]}
    let(:result) {arr.two_sum}

    it "outputs pairs that sum to zero" do
      expect(arr[result[0][0]] + arr[result[0][1]]).to eq 0
      expect(arr[result[1][0]] + arr[result[1][1]]).to eq 0
    end

    it "outputs pairs sorted 'dictionary wise'" do
      expect(result[0][0]).to be < result[0][1]
      expect(result[0][0]).to be < result[1][0]
    end

    it "outputs correct solution" do
      expect(result).to eq([[0, 4], [2, 3]])
    end
  end

  describe "#my_transpose" do
    subject(:matrix) {[
                      [0, 1, 2],
                      [3, 4, 5],
                      [6, 7, 8]
                    ]}
    let(:trans) {[
                  [0, 3, 6],
                  [1, 4, 7],
                  [2, 5, 8]
              ]}

    it "outputs the rows as columns, and viceversa" do
      expect(matrix.my_transpose).to eq trans
    end

  end

  describe "#stock_picker" do
    subject(:arr) {[3, 8, 1, 4, 5, 7, 6]}
    it "outputs most profitable day to buy and to sell" do
      expect(arr.stock_picker).to eq([2, 5])
    end
  end
end