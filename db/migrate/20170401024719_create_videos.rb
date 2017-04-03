class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title, :cover_url_small, :cover_url_large
      t.text :description
      t.timestamps
    end
  end
end
