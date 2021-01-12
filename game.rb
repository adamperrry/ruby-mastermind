require_relative 'input.rb'
require_relative 'display.rb'

# Game instances will display instructions and control the flow of the game.
class Game
  attr_reader :rows, :code, :game_board, :game_mode, :breaker, :maker
  attr_accessor :turn

  include Input
  include Display

  def initialize
    clear_screen
    puts instructions
  end

  def play
    playing = true
    while playing
      new_game
      playing = play_again?
    end
    puts messages('bye')
  end

  private

  def new_game
    game_setup
    @game_board = GameBoard.new(code: code, rows: rows)
    self.turn = -1
    next_turn until game_over
    clear_stdin
    breaker.breaker_end_game(game_over)
    puts 'Code:'
    code_board = GameBoard.new(rows: 1, board: GameBoard.create_row(guess: code))
    puts code_board
  end

  def game_setup
    @game_mode = get_int_between(messages('mode'), 1, 2) # 1 = human breaker, 2 = human maker
    @rows = get_int_between(messages('rows'), 1, 15)
    @breaker = game_mode == 1 ? Human.new : Computer.new
    @maker = game_mode == 1 ? Computer.new : Human.new
    @code = maker.set_code
    clear_screen
  end

  def next_turn
    self.turn += 1
    clear_screen
    four_guesses
    game_board.update_keys(row: turn)
    puts game_board
  end

  def four_guesses
    4.times do |i|
      puts game_board
      puts "Thinking... this may take awhile" if breaker.name == 'Computer'
      game_board.add_guess(row: turn, col: i, guess: breaker.new_guess(game_board))
      clear_screen
    end
  end

  def game_over
    return 'loser' if rows == turn + 1 && game_board.keys_at(turn).uniq != ['red']
    return 'winner' if game_board.keys_at(turn).uniq == ['red']

    false
  end

  def play_again?
    yes_no(messages('again')) == 'y'
  end

  def clear_stdin
    $stdin.getc while $stdin.ready?
  end
end
