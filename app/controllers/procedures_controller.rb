class ProceduresController < ApplicationController
  before_action :logged_in_author
  before_action :correct_author_via, only: [:create, :change_after, :change_before]
  before_action :procedure_correct_author, only: [:update, :destroy]
  
  def create
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @number = Procedure.last_number(@recipe) + 1
    @procedure = @recipe.procedure.build(procedure_params)
    @procedure.number = @number 
    respond_to do |format|
      if @procedure.save
        format.html { redirect_to edit_recipe_path(@recipe) }
        format.js
      else
        format.html { redirect_to edit_recipe_path(@recipe) }
        format.js
      end
    end
  end
  
  def update
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @procedure = @recipe.procedure.find_by(number: params[:number])
    respond_to do |format|
      if @procedure.update_attributes(procedure_params)
        format.html { redirect_to edit_recipe_path(@recipe)}
        format.js
      else
        format.html { redirect_to edit_recipe_path(@recipe)}
        format.js
      end
    end
  end
        
  def change_after
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @procedure = @recipe.procedure.find_by(number: params[:number])
    @next_procedure = @procedure.next_number
    respond_to do |format|
      if @next_procedure
        Procedure.change_content(@procedure, @next_procedure)
        @file_exist = true
        format.html { redirect_to edit_recipe_path(@recipe)}
        format.js
      else
        @file_exist = false
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
      if @previous_procedure
        Procedure.change_content(@procedure, @previous_procedure)
        @file_exist = true
        format.html { redirect_to edit_recipe_path(@recipe)}
        format.js
      else
        @file_exist = false
        format.html { redirect_to edit_recipe_path(@recipe)}
        format.js
      end
    end
  end
  
  def destroy
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @number = params[:number]
    @procedure = @recipe.procedure.find_by(number: @number)
    respond_to do |format|
      if @recipe.procedure.count > 1
        @procedure.destroy_procedure
        format.html { redirect_to edit_recipe_path(@recipe) }
        format.js
      else
        @procedure.update_attributes(content: "")
        format.html { redirect_to edit_recipe_path(@reipe) }
        format.js
      end
    end
  end
  
  private 
  
  def procedure_correct_author
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @user = @recipe.user
  end
  
  def procedure_params
    params.require(:procedure).permit(:number, :content )
  end

end
