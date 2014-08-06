class Card

  attr_reader :value, :type

  def initialize(value, type)
    @value = value
    @type = type
  end
end