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

  def play_round
    user = User.new
    dealer = Dealer.new

    deck = Deck.new
    deck.cards_shuffle

    user.add_card(deck.take_card)
    user.add_card(deck.take_card)

    dealer.add_card(deck.take_card)
    dealer.add_card(deck.take_card)
    
    make_bet(user, dealer, 10)

    while @rounds < 2
      cls

      puts "Игра №#{@rounds += 1}"
      puts "Деньги в игре: #{@money_in_game}"
      puts "Деньги игрока: #{user.bank} ||| Деньги дилера: #{dealer.bank}"
      puts "Карты игрока: #{user.show_cards}, очки игрока: #{user.points}"
      puts "Карты дилера: #{dealer.show_cards(secret=true)}"

      case user.move
      when 1
        user.add_card(deck.take_card)
        dealer.move(deck.take_card)
        break
      when 2 then break
      when 3 then dealer.move(deck.take_card)
      end
    end

    cls
    puts define_winner(user, dealer)

    puts "Деньги игрока: #{user.bank} ||| Деньги дилера: #{dealer.bank}"
    puts "Карты игрока: #{user.show_cards}, очки игрока: #{user.points}"
    puts "Карты дилера: #{dealer.show_cards(secret=false)}, очки дилера: #{dealer.points}"
  end
end