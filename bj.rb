require_relative 'card'
require_relative 'deck'
require_relative 'player'
require_relative 'dealer'
require_relative 'user'
require_relative 'game_methods'

game = GameMethods.new
game.play_round
