require 'sinatra'
require 'json'
require 'csv'
require "sinatra/activerecord"
require './models/score'
require './models/answer'
require './models/team'
require './environments.rb'
require './messages'

def if_valid_key(api_key, &block)
  if Team.valid_api_key?(params[:api_key])
    block.call
  else
    "#{api_key} is not a valid api key"
  end
end

get '/score/:api_key' do
  if_valid_key(params[:api_key]) do 
    scores_left = Score.score_attempts_left_today(params[:api_key])
    "You have #{scores_left} more attempts at scoring today"
  end
end

post '/score/:api_key' do
  api_key = params[:api_key]
  if_valid_key(api_key) do
    request_data = JSON.parse request.body.read
    answers = Answer.all.order(id: :asc).collect { |a| a.answer }
    guesses = request_data["guesses"]

    if guesses.size != answers.size
      return Messages.wrong_number_of_guesses(answers.size, guesses.size) 
    elsif  Score.score_attempts_left_today(api_key) <= 0
      return Messages.too_many_guesses 
    end

    score = Score.calculate_and_record_score(api_key, answers, guesses).score
    if score == 0
      "Yo, you must have done something silly since you got 0.0%. Since you got NOTHING RIGHT, this wont count against your daily limit" 
    else
    "Score: #{score * 100}%"
    end
  end
end

get '/leaderboard' do
  content_type :json
  { leaderboard: Score.leaders }.to_json
end
