class Dealer < Player
  def initialize
    super
  end

  def show_cards(secret)
    secret == true ? secret_cards = (" * " * cards.size).split(" ") : cards
  end
end