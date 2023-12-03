class Player
  attr_reader :cards
  attr_accessor :bank

  def initialize
    @bank = 100
    @cards = []
  end

  def add_card(card)
    @cards << card if cards.size <= 2
  end

  def show_cards
    cards
  end

  def delete_cards
    @cards = []
  end

  def move
  end

  def points
    points = 0
    cards.each do |e|
      if e.include?("K") || e.include?("Q") || e.include?("J") || e.include?("T")
        points += 10
      elsif e.include?("A")
        points += 1
        if points <= 10
          points += 11
        end
      else 
        points += e.chr.to_i
      end
    end
    points
  end
end