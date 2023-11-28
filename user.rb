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