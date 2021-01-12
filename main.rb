require_relative 'colors.rb'
require_relative 'game_board.rb'
require_relative 'game.rb'
require_relative 'human.rb'
require_relative 'computer.rb'
require 'io/wait'

game = Game.new.play
