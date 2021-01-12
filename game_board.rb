# rubocop: disable Metrics/AbcSize

require_relative 'display.rb'

# The gameboard class is responsible for storing the state of the game.
class GameBoard
  include Display
  attr_reader :rows, :code, :board

  def initialize(code: Array.new(4, 'red'), rows: 12, board: empty_board(rows))
    @rows = rows
    @code = code
    @board = board
  end

  def add_guess(row:, col:, guess:)
    board[row][:guess][col] = guess
  end

  def update_keys(row:)
    keys = []
    temp_guess = board[row][:guess].clone
    temp_code = code.clone

    temp_guess.each_with_index do |str, i|
      next unless temp_code[i] == str

      keys.push('red')
      temp_code[i] = 'empty'
      temp_guess[i] = 'found'
    end

    temp_guess.each do |str|
      next unless temp_code.include? str

      keys.push('white')
      temp_code[temp_code.index(str)] = 'empty'
    end

    keys += Array.new(4 - keys.length, 'used') if keys.length != 4
    board[row][:keys] = keys.shuffle
  end

  def pegs_at(row)
    board[row][:guess]
  end

  def keys_at(row)
    board[row][:keys]
  end

  def to_s
    game_rows = board
                .map { |obj| game_row(obj[:guess], obj[:keys]) }
                .join("\n" + middle_row + "\n")
    top_row + "\n" + game_rows + "\n" + bottom_row
  end

  def self.create_row(guess: Array.new(4, 'empty'), keys: Array.new(4, 'empty'))
    [{ guess: guess, keys: keys }]
  end

  private

  def empty_board(rows)
    Array.new(rows) { GameBoard.create_row[0] }
  end
end

# rubocop: enable Metrics/AbcSize
