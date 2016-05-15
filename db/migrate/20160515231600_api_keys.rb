class ApiKeys < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :api_key
    end
  end
end
