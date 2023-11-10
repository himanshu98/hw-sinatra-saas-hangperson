class WordGuesserGame
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.post_form(uri, {}).body
  end

  def initialize(new_word)
    @word = new_word
    @guesses = ''
    @wrong_guesses = ''
  end

  def word
    @word
  end

  def guesses
    @guesses
  end

  def wrong_guesses
    @wrong_guesses
  end

  def guess(char)
    down_char = char.downcase if char

    raise ArgumentError, 'Invalid guess.' if down_char.nil? || /[^A-Za-z]/.match(down_char) || down_char.empty?

    return false if @guesses.include?(down_char) || @wrong_guesses.include?(down_char)

    if @word.include?(char)
      @guesses += char
    else
      @wrong_guesses += char
    end

    true
  end

  def word_with_guesses
    @word.gsub(/[^ #{@guesses}]/, '-')
  end

  def check_win_or_lose
    return :lose if @wrong_guesses.length >= 7
    return :win if word_with_guesses == @word

    :play
  end
end
