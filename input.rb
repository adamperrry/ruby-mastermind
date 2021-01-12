# rubocop: disable Metrics/AbcSize
# rubocop: disable Metrics/PerceivedComplexity
# rubocop: disable Metrics/CyclomaticComplexity

module Input
  def messages(str)
    {
      'rows' => 'Enter number of maximum guesses (typical is 12): ',
      'mode' => 'Please select a game mode (1: BREAK code, 2: SET code): ',
      'code' => "Enter a valid code (e.g. 'b b y c' or 'purple green red red'): ",
      'guess' => "Enter a valid guess (e.g. 'b' or 'blue'): ",
      'win' => 'Congratulations, you win!',
      'lose' => 'Sorry, you lose. Better luck next time!',
      'again' => 'Would you like to play again? (y or n): ',
      'bye' => 'Thanks for playing! Goodbye.'
    }[str]
  end

  def get_int_between(message, min, max, zero = true)
    print message
    int = gets.chomp.to_i
    int = min - 1 if int.zero? && !zero
    until int <= max && int >= min
      puts "Number must be between #{min} & #{max}, inclusive."
      puts " Zero #{'not ' unless zero}included." if (min..max).include? 0
      print message
      int = gets.chomp.to_i
      int = min - 1 if int.zero? && !zero
    end
    int
  end

  def yes_no(message)
    print message
    ans = gets.chomp[0]
    until %w[y n Y N].include? ans
      puts "Please enter 'y' or 'n'."
      print message
      ans = gets.chomp[0]
    end
    ans.downcase
  end

  def get_code(message)
    print message
    code = gets.chomp.split(' ')
               .map { |str| str[0].downcase }
               .select { |str| %w[r g b y p c].include? str }
    until code.length == 4
      puts 'Code must be 4 words or letters separated by spaces.'.red
      puts "E.g. 'blue red red green' or 'p b r y'"
      puts 'Available colors are: red, green, blue, yellow, purple, and cyan.'
      print message
      code = gets.chomp.split(' ')
                 .map { |str| str[0].downcase }
                 .select { |str| %w[r g b y p c].include? str }
    end
    code.map { |str| color(str) }
  end

  def get_guess(message)
    print message
    guess = gets.chomp[0]
    until %w[r R g G b B y Y p P c C].include? guess
      puts 'Guesses should be a valid color or letter.'.red
      puts "E.g. 'blue', 'yellow', or 'y'."
      puts 'Available colors are: red, green, blue, yellow, purple, and cyan.'
      print message
      guess = gets.chomp[0].downcase
    end
    color(guess.downcase)
  end

  def color(color)
    {
      'r' => 'red',
      'b' => 'blue',
      'g' => 'green',
      'p' => 'purple',
      'c' => 'cyan',
      'y' => 'yellow'
    }[color]
  end

  def instructions
    <<~HEREDOC
      #{'Welcome to Mastermind!'.bold.underline.italic}

      Mastermind is a code-breaking game between two players:
        - The code #{'BREAKER'.red.bold}
        - The code #{'SETTER'.red.bold}
      
      The code #{'SETTER'.red.bold} sets the code, which is a sequence of four 
      colors, chosen from the following:
        - #{'Red'.bold.red}, #{'Blue'.bold.blue}, #{'Green'.bold.green}, #{'Yellow'.bold.yellow}, #{'Cyan'.bold.cyan}, #{'Purple'.bold.purple}

      The code #{'BREAKER'.red.bold} attempts to guess the code in the number of turns 
      specified when starting a game. After each guess, four #{'keys'.bold} will be updated 
      to provide hints. A #{'white'.bold.white} key indicates the guess contains a correct
      color in the wrong position, while a #{'red'.bold.red} means a correct color AND position.
      
      #{'NOTE'.bold} that these keys appear in #{'no particular order'.bold}, so the breaker won't 
      explicitly know WHICH colors have been guessed correctly via the keys alone.

      Below is a sample game:

      #{'Code:'.bold.underline}
      #{GameBoard.new(rows: 1, board: [{ guess: %w[red purple purple blue], 
                                         keys: %w[empty empty empty empty] }])}

      #{'Gameplay:'.bold.underline}
      #{GameBoard.new(rows: 5, board: [{ guess: %w[red red blue blue], 
                                         keys: %w[used red used red] }, 
                                       { guess: %w[red red green green], 
                                         keys: %w[used red used used] }, 
                                       { guess: %w[red yellow blue yellow], 
                                         keys: %w[red used white used] }, 
                                       { guess: %w[red purple purple blue], 
                                         keys: %w[red red red red] }, 
                                       { guess: %w[empty empty empty empty], 
                                         keys: %w[empty empty empty empty] }])}

      This program has two game modes:
        - 1: Play as the code #{'BREAKER'.red.bold}, and try to guess a randomly generated code.
        - 2: Play as the code #{'SETTER'.red.bold}, and try to fool the computer's algorithm!
             (Note, the algorithm will likely win in 5 turns on average)
             
    HEREDOC
  end
end

# rubocop: enable Metrics/AbcSize
# rubocop: enable Metrics/PerceivedComplexity
# rubocop: enable Metrics/CyclomaticComplexity
