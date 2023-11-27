class Player
  attr_reader :cards

  def initialize
    @cards = []
  end

  def add_card(card)
    @cards << card
  end

  def delete_cards
    @cards = []
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

  def gets_secret_cards
    @secret_cards.push(' * ' * @cards.size)
  end

  def move
    # to do
  end
end

class User < Player
  attr_accessor :money, :name

  def initialize
    @money = 0
    super
  end

  def enter_user_name
    puts 'Введите Ваше имя:'
    @name = gets.chomp.to_s
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

  def cards_costs(cards)
    @points = 0
    cards.each do |e|
      if e.include?("K") || e.include?("Q") || e.include?("J") || e.include?("T")
        @points += 10
      elsif e.include?("A")
        if @points <= 10
          @points += 11
        else
          @points += 1
        end
      else 
        @points += e.chr.to_i
      end
    end
    @points
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
    @round = 1 # порядковый номер раунда
    @money_in_line = 0 # деньги на кону
  end

  # ход пользователя
  def user_move
    puts "1. Добавить карту"
    puts "2. Открыть карты"
    puts "3. Пас"
    user_move = gets.chomp.to_i
    case user_move
    when 1 
      @user.add_card(@deck.take_card)
    when 2 
      dealer_move
    when 3 then pass
    end
  end

  def dealer_move
    if @deck.cards_costs(@dealer.cards) < 17
      @dealer.add_card(@deck.take_card)
    end
  end

  def pass
    puts "Ходит дилер"
    dealer_move
    show_result
  end

  # сделать рефакторинг
  # подсчитать результаты раунда
  def check_results
    if @deck.cards_costs(@dealer.cards) > 21
      puts "Вы выиграли"
      @user.money += @money_in_line
      @money_in_line = 0
    elsif @deck.cards_costs(@user.cards) > 21
      puts "Вы проиграли"
      @dealer.bank += @money_in_line
      @money_in_line = 0
    elsif @deck.cards_costs(@user.cards) > @deck.cards_costs(@dealer.cards)
      puts "Вы выиграли"
      @user.money += @money_in_line
      @money_in_line = 0
    elsif @deck.cards_costs(@user.cards) < @deck.cards_costs(@dealer.cards)
      puts "Вы проиграли"
      @dealer.bank += @money_in_line
      @money_in_line = 0
    else 
      puts "Ничья"
      @user.money += @money_in_line / 2
      @dealer.bank += @money_in_line / 2
      @money_in_line = 0
    end
  end

  # переход денег к пользователю
  def add_user_money(count)
    @dealer.bank -= count
    @user.money += count
  end

  # переход денег в банк
  def add_bank_money(count)
    @user.money -= count
    @dealer.bank += count
  end

  # ввод денег в игру
  def money_in_game(count)
    @user.money -= count
    @dealer.bank -= count
    @money_in_line += (count * 2)
  end

  # сделать рефакторинг следующих 3-х методов
  # header - общая информация
  def info
    puts
    puts "----------------- Инфо -------------------"
    puts "Раунд №#{@round}. Банк #{@dealer.bank} руб."
    puts "#{@user.name} у вас на счету: #{@user.money} руб."
    puts "На кону: #{@money_in_line} руб."
  end

  # текущий статус игры
  def game_status
    info
    puts "----------------- Игра -------------------"
    puts "Ваши карты: #{@user.cards}"
    puts "Карты дилера: #{@dealer.gets_secret_cards} #{@dealer.cards}debug_info"
    puts "------------------------------------------"
    puts @deck.cards_costs(@user.cards)
  end

  # показать результаты игры
  def show_result
    info
    puts "----------------- Игра -------------------"
    puts "Ваши карты: #{@user.cards}"
    puts "Карты дилера: #{@dealer.cards}"
    puts "------------------------------------------"
    puts @deck.cards_costs(@user.cards)
    puts @deck.cards_costs(@dealer.cards)
  end

  def game_init
     # создаем сущности
     @user = User.new
     @dealer = Dealer.new
     @user.enter_user_name # запрашиваем имя пользователя
     add_user_money(100) # выдаем деньги пользователю
  end

  def play_round
    @user.delete_cards
    @dealer.delete_cards
    @deck = Deck.new
    @deck.cards_shuffle # тусуем карты
    # добавляем карты игроку и дилеру
    @user.add_card(@deck.take_card) 
    @user.add_card(@deck.take_card)
    @dealer.add_card(@deck.take_card)
    @dealer.add_card(@deck.take_card)
    money_in_game(10) # Передаем деньги от игрока и дилера деньги на кон 10 + 10
    puts
    puts "Ставки сделаны"
    game_status # выводим статус с игры (текущие очки, карты, раунд)
    
    loop do
      user_move
      if @user.cards.size <= 3 && @dealer.cards.size <= 3
        show_result
        puts "ИТОГИ ИГРЫ"
        check_results
      end

      puts "Хотите сыграть еще раз? 1(да)/2(нет)"
      user_input = gets.chomp.to_i
      if user_input == 1
        @round += 1
        play_round
      elsif user_input == 2
        puts "Конец игры."
        break
      end
    end
  end

  def play_game
    game_init
    play_round
  end
end

game = Game.new
game.play_game
