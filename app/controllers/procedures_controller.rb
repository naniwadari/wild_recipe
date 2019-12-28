class ProceduresController < ApplicationController

  def create
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @procedure = @recipe.procedure.build(procedure_params)
    #ナンバーがかぶっていた場合はアップデートする
    if proce = @recipe.procedure.find_by(number: @procedure.number)
      proce.update(content: @procedure.content)
      proce.save
      redirect_to edit_recipe_path(@recipe)
    #かぶっていなければ普通にセーブ
    elsif @procedure.save
      redirect_to edit_recipe_path(@recipe)
    else
      render "recipes/edit"
    end
  end

  def update
  end

  def destroy
  end
  
  private 
  
  def procedure_params
    params.require(:procedure).permit(:number, :content )
  end

end
