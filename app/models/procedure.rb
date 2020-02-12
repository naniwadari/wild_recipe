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
    begin
      Procedure.where("(number > ?) AND (recipe_id = ?)", self.number, self.recipe_id).order("number ASC").first
    rescue => e
      return false
    end
  end
  
  #ナンバーが次に小さいレコードを取得
  def previous_number
    begin
      Procedure.where("(number < ?) AND (recipe_id = ?)", self.number, self.recipe_id).order("number DESC").first
    rescue => e
      return false
    end
  end
  
  #最後のナンバーを持つレコードを返す,レコードが無ければゼロを返す
  def self.last_number(recipe)
    proces = recipe.procedure
    if proces.empty?
      return 0
    else
      recipe.procedure.order(number: "DESC").first.number
    end
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
