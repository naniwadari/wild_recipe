class Procedure < ApplicationRecord
  belongs_to :recipe
  
  #一つ後のレコードとコンテンツを入れ替える
  def self.change_content_after(recipe_id, number)
    @recipe = Recipe.find_by(id: recipe_id)
    procedure = @recipe.procedure.find_by(number: number)
    after_procedure = @recipe.procedure.find_by(number: (procedure.number + 1))
    if after_procedure
      temp_content = procedure.content
      procedure.update(content: after_procedure.content)
      after_procedure.update(content: temp_content)
      procedure.save
      after_procedure.save
    end
  end
  
  #一つ前のレコードとコンテンツを入れ替える
  def self.change_content_before(recipe_id, number)
    @recipe = Recipe.find_by(id: recipe_id)
    procedure = @recipe.procedure.find_by(number: number)
    before_procedure = @recipe.procedure.find_by(number: (procedure.number - 1))
    if before_procedure
      temp_content = procedure.content
      procedure.update(content: before_procedure.content)
      before_procedure.update(content: temp_content)
      procedure.save
      before_procedure.save
    end
  end
end
