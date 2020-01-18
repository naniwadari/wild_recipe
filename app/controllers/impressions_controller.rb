class ImpressionsController < ApplicationController
  before_action :correct_author,only: :destroy
  
  def create
    @recipe = Recipe.find_by(id: params[:recipe_id])
    current_user.write_comment(@recipe, params[:comment])
    redirect_to @recipe
  end
  
  #@commentはcorrect_authorで代入
  def destroy
    @recipe = @comment.recipe
    @comment.destroy
    redirect_to @recipe
  end

  private

  def correct_author
    @comment = Impression.find(params[:id])
    unless current_user == @comment.user
      redirect_to root_url
      flash[:danger] = "編集権限がありません"
    end
  end
end
