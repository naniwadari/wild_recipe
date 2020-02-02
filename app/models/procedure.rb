class Procedure < ApplicationRecord
  belongs_to :recipe
  
  #コンテンツを入れ替える
  def self.change_content(procedure, change_procedure)
      temp_content = procedure.content
      procedure.update_attributes(content: change_procedure.content)
      change_procedure.update_attributes(content: temp_content)
  end
  
  #ナンバーが次に大きいレコードを取得
  def next_number
    Procedure.where("(number > ?) AND (recipe_id = ?)", self.number, self.recipe_id).order("number ASC").first
  end
  
  #ナンバーが次に小さいレコードを取得
  def previous_number
    Procedure.where("(number < ?) AND (recipe_id = ?)", self.number, self.recipe_id).order("number DESC").first
  end
end
