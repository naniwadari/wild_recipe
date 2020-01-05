class ProceduresController < ApplicationController
  before_action :logged_in_author
  before_action :correct_author_via
  
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
  
  def change_after
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @change_after = Procedure.find_by(recipe_id: @recipe.id, number: params[:number])
    if @change_after.present?
      Procedure.change_content_after(@recipe.id, @change_after.number)
      redirect_to edit_recipe_path(@recipe)
    else
      redirect_to edit_recipe_path(@recipe)
    end
  end
  
  def change_before
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @change_before = Procedure.find_by(recipe_id: @recipe.id, number: params[:number])
    if @change_before.present?
      Procedure.change_content_before(@recipe.id, @change_before.number)
      redirect_to edit_recipe_path(@recipe)
    else
      redirect_to edit_recipe_path(@recipe)
    end
  end
  
  def destroy
  end
  
  private 
  
  def procedure_params
    params.require(:procedure).permit(:number, :content )
  end

end
