require './test/test_helper'
require  './messages'
require 'rack/test'
require 'json'

describe "API" do
  include Rack::Test::Methods

  h = {'Content-Type' => 'application/json'}

  before do
    Score.delete_all
    Answer.delete_all
    Team.delete_all

    Team.create(api_key: "123", name: "team1")
    Answer.create(answer: "1")
  end

  def app
    Sinatra::Application    
  end

  it "should say you have 3 scores left if you have made no guesses yet today" do
    get "/score/123" 
    assert_equal "You have 3 more attempts at scoring today", last_response.body
  end

  it "should accept a score request" do
    post("/score/123", { guesses: [1] }.to_json, h)
    assert_equal 1, Score.all.size
    assert_equal "Score: 100.0%", last_response.body
  end

  it "should decrement # of available guesses after a score attempt" do
    get "/score/123" 
    assert_equal "You have 3 more attempts at scoring today", last_response.body

    post("/score/123", { guesses: [1] }.to_json, h)

    get "/score/123" 
    assert_equal "You have 2 more attempts at scoring today", last_response.body
  end

  it "should not allow more than 3 scores per day" do
    post("/score/123", { guesses: [1] }.to_json, h)
    post("/score/123", { guesses: [1] }.to_json, h)
    post("/score/123", { guesses: [1] }.to_json, h)
    assert_equal 3, Score.all.size

    get "/score/123" 
    assert_equal "You have 0 more attempts at scoring today", last_response.body


    post("/score/123", { guesses: [1] }.to_json, h)
    assert_equal Messages.too_many_guesses, last_response.body
    assert_equal 3, Score.all.size
  end

  it "should check that the api_keys are valid" do
    expected = "madeUpKey is not a valid api key"
    get "/score/madeUpKey"
    assert_equal expected, last_response.body

    post("/score/madeUpKey", { guesses: [1] }.to_json, h)
    assert_equal expected, last_response.body
  end
end
