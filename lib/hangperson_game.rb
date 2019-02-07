class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :word_with_guesses
  attr_accessor :check_win_or_lose

  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = word.gsub(/[[:alpha:]]/, "-")
    @check_win_or_lose = :play
    @wrong_count = 0
  end

  def guess(guessChar)
    if guessChar == '' || guessChar == nil || guessChar !~ /[[:alpha:]]/
      raise ArgumentError
    end

    guessChar = guessChar.downcase 

    if @word.include? guessChar
      if !@guesses.include? guessChar
        @guesses = @guesses + guessChar

        indices = (0 ... @word.length).find_all { |i| @word[i,1] == guessChar }
        indices.each do |i|
          @word_with_guesses[i] = guessChar
        end

        if(@word_with_guesses == @word) 
          @check_win_or_lose = :win
        end

        true
      else
        false
      end
    else
      if !@wrong_guesses.include? guessChar
        @wrong_guesses = @wrong_guesses + guessChar
        @wrong_count = @wrong_count + 1
        
        if(@wrong_count >= 7)
          @check_win_or_lose = :lose
        end
    
        true
      else
        false
      end
    end
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
