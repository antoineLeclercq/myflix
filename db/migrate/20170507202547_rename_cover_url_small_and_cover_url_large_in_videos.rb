class RenameCoverUrlSmallAndCoverUrlLargeInVideos < ActiveRecord::Migration
  def change
    rename_column :videos, :cover_url_small, :small_cover
    rename_column :videos, :cover_url_large, :large_cover
  end
end
