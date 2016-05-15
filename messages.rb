module Messages
  def self.wrong_number_of_guesses(answer_size, guesses_size)
    "The test data set has #{answers_size} rows, but you submitted guesses for #{guesses_size} rows. Since you made a boobo, this wont count against your API limit"
  end

  def self.too_many_guesses
    "Yo: you have submitted too many guesses for today, try again tomorrow!"
  end
end
