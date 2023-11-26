class Player
	attr_reader :cards

	def initialize
		@cards = []
    @points = 0
	end

	def add_card(card)
    @cards << card
	end

  # to do refactoring!
  def cards_costs(cards)
    cards.each do |e|
      if e.include?("K")
        @points += 10
      elsif e.include?("Q")
        @points += 10
      elsif e.include?("J")
        @points += 10
      elsif e.include?("T")
        @points += 10
      elsif e.include?("9")
        @points += 9
      elsif e.include?("8")
        @points += 8
      elsif e.include?("7")
        @points += 7
      elsif e.include?("6")
        @points += 6
      elsif e.include?("5")
        @points += 5
      elsif e.include?("4")
        @points += 4
      elsif e.include?("3")
        @points += 3
      elsif e.include?("2")
        @points += 2
      elsif e.include?("A")
        if @points <= 10
          @points += 11
        else
          @points += 1
        end
      end
    end
    @points
  end
end

class Dealer < Player
  attr_reader :secret_cards
	attr_accessor :bank
	
	def initialize
		@bank = 10_000
		@secret_cards = []
    super
	end

  def get_secret_cards
    @secret_cards.push(" * " * @cards.size)
  end
end

class User < Player
  attr_accessor :money, :name

  def initialize
    @money = 0
    super
  end
end

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

class Game
  def initialize
    puts 'Welcome Black Jack v1.0'
    @round = 1
    @wins = 0
    @flag = true
    @money_in_line = 0
    @points = 0
  end

  def menu
    puts "Меню игры:"
    puts '1. Новая игра'
    puts '2. Показать правила'
    puts '0. Выйти'
    user_move = gets.chomp.to_i
    case user_move
    when 1 then play_round
    when 2 then show_rules
    when 0 
      puts "exit"
    else 
      puts "Такого значения не существует"
    end
  end

  def show_rules
    pust "Правила игры:"
  end

  def user_choose
    puts "1. Добавить карту"
    puts "2. Открыть карты"
    puts "3. Сделать ставку."
    puts "4. Пас"
    user_move = gets.chomp.to_i
    case user_move
    when 1 then money_in_game(make_bet)
    when 2 then show_result
    when 3 then money_in_game(make_bet)
    when 4 then pass
    end
  end

  def pass
    # to do
  end

  def info
    puts
    puts "----------------- Инфо -------------------"
    puts "Раунд №#{@round}. Победы: #{@wins}. Банк #{@dealer.bank} руб."
    puts "У вас на счету: #{@user.money} руб."
    puts "На кону: #{@money_in_line} руб."
  end

  def show_result
    info
    puts "----------------- Игра -------------------"
    puts "Ваши карты: #{@user.cards}"
    puts "Карты дилера: #{@dealer.cards}"
    puts "------------------------------------------"
    puts @user.cards_costs(@user.cards)
    puts @dealer.cards_costs(@dealer.cards)
    check_results
  end

  def check_results
    if @user.cards_costs(@user.cards) <= 21 || @user.cards_costs(@user.cards) > @dealer.cards_costs(@dealer.cards)
      puts "Вы выиграли"
    elsif @user.cards_costs(@user.cards) == @dealer.cards_costs(@dealer.cards)
      puts "Ничья"
    else
      puts "Вы проиграли"
    end
  end

  def make_bet
    puts 'Ваша ставка?'
    @bet = gets.chomp_to_i
  end

  def enter_user_name
    puts 'Enter name:'
    @user.name = gets.chomp.to_s
  end

  def add_user_money(count)
    @dealer.bank -= count
    @user.money += count
  end

  def add_bank_money(count)
    @user.money -= count
    @dealer.bank += count
  end

  def money_in_game(count)
    @user.money -= count
    @dealer.bank -= count
    @money_in_line += (count * 2)
  end

  def game_status
    info
    puts "----------------- Игра -------------------"
    puts "Ваши карты: #{@user.cards}"
    puts "Карты дилера: #{@dealer.get_secret_cards}"
    puts "------------------------------------------"
    puts @user.cards_costs(@user.cards)
  end

  def play_round
    @user = User.new
    @dealer = Dealer.new
    @deck = Deck.new

    enter_user_name
    add_user_money(100)
    @deck.cards_shuffle
    @user.add_card(@deck.take_card)
    @user.add_card(@deck.take_card)
    @dealer.add_card(@deck.take_card)
    @dealer.add_card(@deck.take_card)
    @dealer.get_secret_cards
    money_in_game(20)

    puts "Ставки сделаны"
    game_status

    user_choose
    check_results
  end

  def lets_play
    # loop do
      menu
      play_round
      user_choose
      check_results
    # end
  end
end

game = Game.new
game.play_round
