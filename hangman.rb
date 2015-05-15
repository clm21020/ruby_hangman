class Hangman
  MAX_MISSES ||= 10
  attr_accessor :picker, :guesser, :guesses

  def initialize(picker, guesser)
    @picker = (picker == "computer") ? Computer.new : Human.new
    @guesser = (guesser == "computer") ? Computer.new : Human.new
    @correct_guesses = []
  end

  def game_won?(status)
    !status.include?('_')
  end

  def play
    status = ""
    length = @picker.pick_secret_word
    @guesser.receive_secret_length(length)
    status = "_" * length
    misses = 0

    while misses < MAX_MISSES && !game_won?(status)
       print_status(status)
       guess = @guesser.guess(@correct_guesses)

       if @picker.check_guess(guess)
         @correct_guesses << guess
         status = @picker.handle_guess_response(@correct_guesses)
       else
         misses += 1
       end
    end
     print_end_game_message(game_won?(status))

  end

  def print_end_game_message(game_was_won)
    game_was_won ? (puts "Congratulations!") : (puts "Hanged!")
  end

  def print_status(status)
    puts status
  end
end


class Human
  def pick_secret_word
    puts "How long is your word?"
    foo = gets.chomp.to_i
    puts "foo: #{foo}"
    foo
  end

  def receive_secret_length(secret_length)
    @secret_length = secret_length
  end

  def guess(correct_guesses)
    puts "Correct guesses so far: #{correct_guesses}."
    puts "Enter next guess: "
    gets.chomp
  end

  def check_guess(guess)
    puts "Is #{guess} correct? (y/n): "
    gets[0] == "y" ? true : false
  end

  def handle_guess_response(correct_guesses)
    puts "Correct guesses so far: #{correct_guesses}"
    puts "Please enter status ('h_ngm_n')"
    gets.chomp
  end
end

class Computer
  def initialize
    @dictionary = get_dictionary
    @remaining_letters = ("a".."z").to_a
  end

  def pick_secret_word
    @word = @dictionary.sample
    @word.length
  end

  def receive_secret_length(secret_length)
    @secret_length = secret_length
  end

  def guess(correct_guesses)
    guess = @remaining_letters.sample
    @remaining_letters.delete(guess)
    guess
  end

  def check_guess(guess)
     @word.include?(guess)

  end

  def handle_guess_response(correct_guesses)
    result = ""
    @word.each_char do |char|
      if correct_guesses.include?(char)
        result << char
      else
        result << "_"
      end
    end
    result
  end

  private
    def get_dictionary
      File.readlines("dictionary.txt").map(&:chomp)
    end

end
