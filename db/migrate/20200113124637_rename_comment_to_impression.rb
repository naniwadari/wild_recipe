class RenameCommentToImpression < ActiveRecord::Migration[5.1]
  def change
    rename_table :comments, :impressions
  end
end
