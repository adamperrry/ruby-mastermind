require_relative 'input.rb'

class Computer
  include Input
  attr_reader :colors, :all_guesses
  attr_accessor :s, :turn, :index, :guess

  def initialize
    @name = 'Computer'
    @colors = %w[red blue green yellow purple cyan]
    @all_guesses = colors.repeated_permutation(4).to_a
    @s = all_guesses.clone
    @turn = 0
    @guess = %w[red red blue blue]
  end

  def set_code
    code = []
    4.times { code.push(colors.sample) }
    code
  end

  def new_guess(game_board)
    update_turn(game_board)
    update_index(game_board)
    update_guess(game_board)
    all_guesses.delete(guess)

    sleep 0.25
    guess[index]
  end

  def breaker_end_game(status)
    puts status == 'winner' ? messages('lose') : messages('win')
  end

  private

  def update_turn(game_board)
    self.turn += 1 until game_board.board[turn][:keys].include? 'empty'
  end

  def update_index(game_board)
    self.index = 4 - game_board.board[turn][:guess].count('empty')
  end

  def update_guess(game_board)
    return if turn.zero? || !index.zero?

    previous_keys = game_board.board[turn - 1][:keys]
    num_red = previous_keys.count('red')
    num_white = previous_keys.count('white')

    if (num_red + num_white).zero?
      no_keys_update_s
    else
      keys_update_s(reds: num_red, whites: num_white)
    end

    results = minimax
    pick_guess(results)
  end

  def pick_guess(results)
    results.sort_by! { |i, score| [score, i] }
    min_score = results[0][1]
    min_set = results.select { |arr| arr[1] == min_score }
    min_set_in_s = min_set.select { |arr| s.include? all_guesses[arr[0]] }
    self.guess = if min_set_in_s.empty?
                   all_guesses[min_set[0][0]]
                 else
                   all_guesses[min_set_in_s[0][0]]
                 end
  end

  def minimax
    results = {}
    all_guesses.each_with_index do |arr, i|
      scores = []
      possible_keys.each do |keys|
        score = hit_count(arr, keys[0], keys[1])
        scores.push(score)
      end
      # scores.push(0) if scores.empty?
      results[i] = scores.max
    end
    results.to_a
  end

  def hit_count(arr, num_keys, reds)
    s.select { |e| common(e, arr) == num_keys && exact(e, arr) != reds }.length
  end

  def possible_keys
    # each element is an array of the form [total keys, red keys]
    # represents all possible white/red key results
    arr = [0, 1, 2, 3, 4]
    arr.repeated_permutation(2).select { |a| a[1] >= a[0] }
  end

  def no_keys_update_s
    s.delete_if { |arr| !(arr & guess).empty? }
    all_guesses.delete_if { |arr| !(arr & guess).empty? }
  end

  def keys_update_s(reds:, whites:)
    num_keys = reds + whites
    s.keep_if { |arr| common(arr, guess) == num_keys && exact(arr, guess) == reds }
  end

  def common(arr1, arr2)
    (arr1 & arr2).flat_map { |n| [n] * [arr1.count(n), arr2.count(n)].min }.length
  end

  def exact(arr1, arr2)
    count = 0
    arr1.each_with_index { |val, i| count += 1 if arr2[i] == val }
    count
  end
end
