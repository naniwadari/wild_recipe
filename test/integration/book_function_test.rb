require 'test_helper'

class BookFunctionTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:recipeman)
    @recipe = recipes(:suberihiyu)
  end
  
  #ブックマークとブックマーク取り消し成功
  test "successful book and unbook" do
    log_in_as(@user)
    get recipe_path(@recipe)
    #ブックマークボタン
    assert_select "form[action=?]", "/books"
    #データ送信
    assert_difference "Book.count", 1 do
      post books_path, params:{ recipe_id: @recipe.id }, xhr: true
    end
    get recipe_path(@recipe)
    assert_select "form[action=?]", "/books/#{(Book.last.id)}"
    assert_difference "Book.count", -1 do
      delete book_path(@user.books.find_by(recipe_id: @recipe.id)),
             params:{ recipe_id: @recipe.id}
    end
  end
end
