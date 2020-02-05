class Procedure < ApplicationRecord
  belongs_to :recipe
  
  #コンテンツを入れ替える
  def self.change_content(procedure = nil, change_procedure = nil)
    begin
      temp_content = procedure.content
      procedure.update_attributes(content: change_procedure.content)
      change_procedure.update_attributes(content: temp_content)
    rescue => e
      return false
    end
  end
  
  #ナンバーが次に大きいレコードを取得
  def next_number
    Procedure.where("(number > ?) AND (recipe_id = ?)", self.number, self.recipe_id).order("number ASC").first
  end
  
  #ナンバーが次に小さいレコードを取得
  def previous_number
    Procedure.where("(number < ?) AND (recipe_id = ?)", self.number, self.recipe_id).order("number DESC").first
  end
  
  #ナンバーが下のレコードのナンバーを-1して削除する
  def destroy_procedure
    self.lower_number.each do |procedure|
      procedure.update_attributes(number: (procedure.number - 1))
    end
    self.destroy
  end
  
  #自分が持つナンバーより下のナンバーを持つレコードを取得
  def lower_number
    Procedure.where("(number > ?) AND (recipe_id = ?)", self.number, self.recipe_id)
  end
end
