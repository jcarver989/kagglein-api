require './test/test_helper'

describe Team do
  before do
    Team.delete_all
  end

  it "does not accept a api key that does not exit" do
    assert_equal Team.valid_api_key?("123"), false 
  end

  it "does accept a api key that exists" do
    Team.create(api_key: "123", name: "a team") 
    assert_equal Team.valid_api_key?("123"), true 
  end
end
