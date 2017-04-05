class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id, :video_id
      t.text :body
      t.integer :rating
    end
  end
end
