require './test/test_helper'

describe Score do
  before do
    Score.delete_all
  end

  it "can calculate a score" do 
    score = Score.calculate_and_record_score("123", [1,0], [1,1])
    assert_equal Score.all.size, 1
    assert_equal score.api_key, "123"
    assert_equal score.score, 0.5
  end

  it "can calculate scores from multiple api_keys" do 
    score1 = Score.calculate_and_record_score("456", [1,0], [1,1])
    assert_equal Score.all.size, 1
    assert_equal score1.api_key, "456"
    assert_equal score1.score, 0.5

    score2 = Score.calculate_and_record_score("123", [1,1], [1,1])
    assert_equal Score.all.size, 2
    assert_equal score2.api_key, "123"
    assert_equal score2.score, 1 
  end

  it "gives 3 attempts when no attempts today have been made" do
    assert_equal Score.score_attempts_left_today("123"), 3
  end

  it "gives 2 attempts when 1 attempt today has been made" do
    Score.calculate_and_record_score("123", [1,0], [1,1])
    assert_equal Score.score_attempts_left_today("123"), 2 
  end

  it "never says less than 0 attempts " do
    Score.calculate_and_record_score("123", [1,0], [1,1])
    Score.calculate_and_record_score("123", [1,0], [1,1])
    Score.calculate_and_record_score("123", [1,0], [1,1])
    Score.calculate_and_record_score("123", [1,0], [1,1])
    assert_equal Score.score_attempts_left_today("123"), 0 
  end

  it "allows new score attempts after 1 day has passed" do 
    Timecop.travel(1.day.ago) do
      Score.calculate_and_record_score("123", [1,0], [1,1])
      Score.calculate_and_record_score("123", [1,0], [1,1])
      Score.calculate_and_record_score("123", [1,0], [1,1])
      assert_equal Score.score_attempts_left_today("123"), 0 
    end

    assert_equal Score.score_attempts_left_today("123"), 3 
  end
end
