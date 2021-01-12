require_relative 'input.rb'

class Human
  include Input

  def initialize
    @name = 'Human'
  end

  def set_code
    get_code(messages('code'))
  end

  def new_guess(_game_board)
    get_guess(messages('guess'))
  end

  def breaker_end_game(status)
    puts status == 'winner' ? messages('win') : messages('lose')
  end
end
