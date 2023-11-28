class User < Player
  attr_accessor :name

  def initialize
    super
  end

  def enter_user_name
    puts 'Введите Ваше имя:'
    @name = gets.chomp.to_s
  end

  def move(card)
    puts "1. Добавить карту"
    puts "2. Открыть карты"
    puts "3. Пас"
    guess = gets.chomp.to_i
    case guess
    when 1 then self.add_card(card)
    when 2 then # to do
    when 3 then # to do
    end
  end
end