class ImpressionsController < ApplicationController
  before_action :correct_author,only: :destroy
  before_action :logged_in_user
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

  def logged_in_user
    @recipe = Recipe.find_by(id: params[:recipe_id])
    unless logged_in?
      flash[:danger] = "コメントを書き込むにはログインしてください"
      redirect_to @recipe
    end
  end
end
