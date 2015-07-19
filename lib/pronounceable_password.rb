require 'csv'

class PronounceablePassword


  def initialize(probability_corpus)
    # probability corpus is the file location of the CSV with the
    # pre-calculated letter probability pairs
    @probability_corpus = probability_corpus
  end

  def read_probabilities
    # Should consume the provided CSV file into a structure that
    # can be used to identify the most probably next letter
    probabilities = []
    CSV.foreach(@probability_corpus, headers: true) do |row|
      probabilities << { row["letter pair"] => row["count"].to_i }
    end
    @probabilities = probabilities.reduce Hash.new, :merge
  end

  def possible_next_letters(letter)
    # Should return an array of possible next letters sorted
    # by likelyhood in a descending order
    next_letters = @probabilities.select {|k, v| k[0].include? letter}
    next_letters_desc = Hash[next_letters.sort_by {|k, v| v}.reverse]
    @array_of_possible_next_letters = next_letters_desc.map {|k, v| {k => v}}
  end

  def most_common_next_letter(letter)
    # The most probable next letter
      self.possible_next_letters(letter).first.keys[0][1]
  end

  def common_next_letter(letter, sample_limit = 2)
    # Randomly select a common letter within a range defined by
    # the sample limit as the lower bounds of a substring
    self.possible_next_letters(letter).first(sample_limit).each{|hash| return hash.keys[0][1]}
  end
end
