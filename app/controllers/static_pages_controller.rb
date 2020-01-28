class StaticPagesController < ApplicationController
  
  def home
    @latest_recipes = Recipe.latest(5)
  end
  
  def about
  end
end
