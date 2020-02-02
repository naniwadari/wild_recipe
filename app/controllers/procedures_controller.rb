class ProceduresController < ApplicationController
  before_action :logged_in_author
  before_action :correct_author_via
  
  def create
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @procedure = @recipe.procedure.build(procedure_params)
    proce = @recipe.procedure.find_by(number: @procedure.number)
    #ナンバーがかぶっていた場合はアップデートする
    if proce.present?
      proce.update_attributes(content: @procedure.content)
      respond_to do |format|
        format.js
      end
      return
    #かぶっていなければ普通にセーブ
    elsif @procedure.save
      respond_to do |format|
        format.js
      end
    else
      render "recipes/edit"
    end
  end
  
  def change_after
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @procedure = @recipe.procedure.find_by(number: params[:number])
    @next_procedure = @procedure.next_number
    respond_to do |format|
      if @next_procedure.present?
        Procedure.change_content(@procedure, @next_procedure)
        format.html { redirect_to edit_recipe_path(@recipe)}
        format.js
      else
        redirect_to edit_recipe_path(@recipe)
      end
    end
  end
  
  def change_before
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @procedure = @recipe.procedure.find_by(number: params[:number])
    @previous_procedure = @procedure.previous_number
    respond_to do |format|
      if @previous_procedure.present?
        Procedure.change_content(@procedure, @previous_procedure)
        format.html { redirect_to edit_recipe_path(@recipe)}
        format.js
      else
        return false
      end
    end
  end
  
  def destroy
  end
  
  private 
  
  def procedure_params
    params.require(:procedure).permit(:number, :content )
  end

end
