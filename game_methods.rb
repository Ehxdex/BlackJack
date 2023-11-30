class GameMethods
  def initialize
    @rounds = 0
  end

  def cls
    system 'clear' or system 'cls'
  end

  def define_winner(user, dealer)
    if dealer.points > 21 && dealer.points != user.points
      "Победил игрок"
    elsif user.points > 21 && dealer.points != user.points
      "Победил дилер"
    elsif user.points > dealer.points
      "Победил игрок"
    elsif user.points < dealer.points
      "Победил дилер"
    else 
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
    
    while @rounds < 2
      cls
      puts "Ход №#{@rounds += 1}"
      puts "Деньги игрока: #{user.bank} ||| Деньги дилера: #{dealer.bank}"
      puts "Карты игрока: #{user.show_cards}, очки игрока: #{user.points}"
      puts "Карты дилера: #{dealer.show_cards(secret=true)}"

      case user.move
      when 1
        user.add_card(deck.take_card)
        user.add_card(deck.take_card)
        dealer.move(deck.take_card)
        break
      when 2 then break
      when 3 then dealer.move(deck.take_card)
      end
    end

    puts "Деньги игрока: #{user.bank} ||| Деньги дилера: #{dealer.bank}"
    puts "Карты игрока: #{user.show_cards}, очки игрока: #{user.points}"
    puts "Карты дилера: #{dealer.show_cards(secret=false)}, очки дилера: #{dealer.points}"
    
    puts define_winner(user, dealer)
  end
end