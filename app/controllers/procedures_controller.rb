class ProceduresController < ApplicationController
  before_action :logged_in_author
  before_action :correct_author_via, only: [:create, :change_after, :change_before]
  before_action :procedure_correct_author, only: :destroy
  
  def create
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @procedure = @recipe.procedure.build(procedure_params)
    proce = @recipe.procedure.find_by(number: @procedure.number)
    #ナンバーがかぶっていた場合はアップデートする
    respond_to do |format|
      if proce.present?
        proce.update_attributes(content: @procedure.content)
        format.html { redirect_to edit_recipe_path(@recipe) }
        format.js
        return
      #かぶっていなければ普通にセーブ
      elsif @procedure.save
        format.html { redirect_to edit_recipe_path(@recipe) }
        format.js
      else
        format.html { redirect_to edit_recipe_path(@recipe) }
        format.js
      end
    end
  end
  
  def change_after
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @procedure = @recipe.procedure.find_by(number: params[:number])
    @next_procedure = @procedure.next_number
    respond_to do |format|
      if Procedure.change_content(@procedure, @next_procedure)
        format.html { redirect_to edit_recipe_path(@recipe)}
        format.js
      else
        format.html { redirect_to edit_recipe_path(@recipe)}
        format.js
      end
    end
  end
  
  def change_before
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @procedure = @recipe.procedure.find_by(number: params[:number])
    @previous_procedure = @procedure.previous_number
    respond_to do |format|
      if Procedure.change_content(@procedure, @previous_procedure)
        format.html { redirect_to edit_recipe_path(@recipe)}
        format.js
      else
        format.html { redirect_to edit_recipe_path(@recipe)}
        format.js
      end
    end
  end
  
  def destroy
    @procedure = Procedure.find(params[:id])
    @recipe = @procedure.recipe
    @procedure.destroy_procedure
    respond_to do |format|
      format.html { redirect_to edit_recipe_path(@recipe) }
      format.js
    end
  end
  
  private 
  
  def procedure_correct_author
    @recipe = Procedure.find(params[:id]).recipe
    @user = @recipe.user
  end
  
  def procedure_params
    params.require(:procedure).permit(:number, :content )
  end

end
