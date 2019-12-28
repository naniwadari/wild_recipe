class Procedure < ApplicationRecord
  belongs_to :recipe
  
  #一つ後のレコードとコンテンツを入れ替える
  def self.change_content_after(recipe_id, number)
    @recipe = Recipe.find_by(id: recipe_id)
    procedure = @recipe.procedure.find_by(number: number)
    rear_procedure = @recipe.procedure.find_by(number: (procedure.number + 1))
    if rear_procedure
      temp_content = procedure.content
      procedure.update(content: rear_procedure.content)
      rear_procedure.update(content: temp_content)
      procedure.save
      rear_procedure.save
    else
      
    end
  end
  
  def change_content_before
  end
end
