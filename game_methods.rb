class GameMethods
  def initialize
    @rounds = 0
  end

  def cls
    system 'clear' or system 'cls'
  end

  def make_bet(user, dealer, bet)
    @money_in_game = bet * 2
    user.bank -= bet 
    dealer.bank -= bet
  end

  def define_winner(user, dealer)
    if dealer.points > 21 && dealer.points != user.points
      user.bank += @money_in_game
      "Победил игрок"
    elsif user.points > 21 && dealer.points != user.points
      dealer.bank += @money_in_game
      "Победил дилер"
    elsif user.points > dealer.points
      user.bank += @money_in_game
      "Победил игрок"
    elsif user.points < dealer.points
      dealer.bank += @money_in_game
      "Победил дилер"
    else 
      user.bank += @money_in_game / 2
      dealer.bank += @money_in_game / 2
      "Ничья"
    end
  end

  def play_round(user, dealer, deck)
    cls

    puts "Игра №#{@rounds += 1}"
    puts "Деньги в игре: #{@money_in_game}"
    puts "Деньги игрока: #{user.bank} ||| Деньги дилера: #{dealer.bank}"
    puts "Карты игрока: #{user.show_cards}, очки игрока: #{user.points}"
    puts "Карты дилера: #{dealer.show_cards(secret=true)}"

    while true
      case user.move
      when 1
        user.add_card(deck.take_card)
        dealer.move(deck.take_card)
        break
      when 2 then break
      when 3
        dealer.move(deck.take_card)
        break
      end
    end
    
    cls
    puts define_winner(user, dealer)

    puts "Деньги игрока: #{user.bank} ||| Деньги дилера: #{dealer.bank}"
    puts "Карты игрока: #{user.show_cards}, очки игрока: #{user.points}"
    puts "Карты дилера: #{dealer.show_cards(secret=false)}, очки дилера: #{dealer.points}"
  end

  def start_game
    user = User.new
    dealer = Dealer.new

    while true
      user.delete_cards
      dealer.delete_cards

      deck = Deck.new
      deck.cards_shuffle

      user.add_card(deck.take_card)
      user.add_card(deck.take_card)

      dealer.add_card(deck.take_card)
      dealer.add_card(deck.take_card)
      
      make_bet(user, dealer, 10)

      play_round(user, dealer, deck)

      puts "Хотите сыграть еще раунд y(yes)/n(no)"
      guess = gets.chomp
      
      if guess == "y" || guess == "yes"
        play_round(user, dealer, deck)
      else
        puts "Конец игры"
        break
      end
    end
  end
end