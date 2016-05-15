class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.float :score
      t.string :api_key
      t.timestamps
    end
  end
end
