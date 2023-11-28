class Card
  attr_accessor :suit, :rank
end

class Deck
  attr_accessor :deck

  def initialize
    @deck = generate_deck
  end

  def cards_shuffle
    @deck.shuffle!
  end

  def take_card
    @deck.pop
  end

  private

  def generate_deck
    deck = [], suits = [], ranks = []
    card = Card.new
    ["\u2660","\u2665","\u2666","\u2663"].each do |element|
      suits << card.suit = element
    end

    '23456789TJQKA'.chars.each do |element|
      ranks << card.rank = element
    end

    deck = ranks.product(suits).map(&:join) 
  end
end

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

  def delete_cards
    @cards = []
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

class Dealer < Player

  def initialize
    super
  end

  def show_cards
    @secret_cards.push(' * ' * @cards.size)
  end
end

class User < Player
  attr_accessor :name

  def initialize
    super
  end

  def enter_user_name
    puts 'Введите Ваше имя:'
    @name = gets.chomp.to_s
  end
end

class Game
  def define_winner(user, dealer)
    if dealer.points > 21
      puts "Вы выиграли"
    elsif user.points > 21
      puts "Вы проиграли"
    elsif user.points > dealer.points
      puts "Вы выиграли"
    elsif user.points < dealer.points
      puts "Вы проиграли"
    else 
      puts "Ничья"
    end
  end

  def play_round
    user = User.new
    dealer = Player.new

    deck = Deck.new
    deck.cards_shuffle

    user.add_card(deck.take_card)
    user.add_card(deck.take_card)

    dealer.add_card(deck.take_card)
    dealer.add_card(deck.take_card)

    puts "Ваши деньги: #{user.bank} | Деньги дилера #{dealer.bank}"
    puts "Карты игрока: #{user.cards}, ваши очки: #{user.points}"
    puts "Карты дилера: #{dealer.cards}, очки дилера: #{dealer.points}"

    define_winner(user, dealer)
  end
end

game = Game.new
game.play_round
