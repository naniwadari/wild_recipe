class StaticPagesController < ApplicationController
  
  def home
    @recipes = Recipe.latest(5)
  end
  
  def about
  end
end
