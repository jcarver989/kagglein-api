require "sinatra/activerecord"

class Team < ActiveRecord::Base
  def self.valid_api_key?(api_key)
    Team.where(api_key: api_key).size > 0
  end
end
