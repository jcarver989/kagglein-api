require "sinatra/activerecord"

class Score < ActiveRecord::Base
  @@max_guesses_per_day = 3
  
  def self.score_attempts_left_today(api_key)
    now = Time.now
    time_range = (now - 1.day)..now
    recent_scores = Score.where(api_key: api_key, created_at: time_range)
    [@@max_guesses_per_day - recent_scores.size, 0].max
  end

  def self.calculate_and_record_score(api_key, answers, guesses)
    correct = 0
    guesses.each_with_index do |guess, i|
      correct += 1 if guess.to_s == answers[i].to_s
    end

    score = correct / answers.size.to_f
    Score.create(api_key: api_key, score: score)
  end
end
