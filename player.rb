class Player
  attr_reader :cards
  attr_accessor :bank

  def initialize
    @bank = 100
    @cards = []
  end

  def add_card(card)
    @cards << card
  end

  def show_cards
    cards
  end

  def points
    points = 0
    cards.each do |e|
      if e.include?("K") || e.include?("Q") || e.include?("J") || e.include?("T")
        points += 10
      elsif e.include?("A")
        if points <= 10
          points += 11
        else
          points += 1
        end
      else 
        points += e.chr.to_i
      end
    end
    points
  end
end