class GameMethods
  def cls
    system 'clear' or system 'cls'
  end

  def define_winner(user, dealer)
    if dealer.points > 21
      "Победил игрок"
    elsif user.points > 21
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

    dealer.move(deck.take_card)
    user.move(deck.take_card)

    puts "Деньги игрока: #{user.bank} ||| Деньги дилера: #{dealer.bank}"
    puts "Карты игрока: #{user.show_cards}, очки игрока: #{user.points}"
    puts "Карты дилера: #{dealer.show_cards(secret=false)}, очки дилера: #{dealer.points}"

    puts define_winner(user, dealer)
  end
end