class IngredientCollection
  #recipes/editビューから送られてきたデータを配列に入れて処理するためのクラス
  #クラスをモデル化することでモデルが持つメソッドを利用できるようにしている
  
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  attr_accessor :collection #作成した材料モデルが格納される仮属性
  
  #初期化メソッド
  def initialize(attributes = [], recipe )
    #attributesに値が入っていればcollectionに材料データを入れ込んだ配列を代入する
    if attributes.present?
      self.collection = attributes.map do |value|
        recipe.ingredient.build(
          name: value[:name],
          amount: value[:amount] )
      end
      self.collection.each_with_index do |value, i|
        value.number = "#{ (i + 1) }"
      end
    else
      self.collection = recipe.ingredient.map
    end
  end

  def save
    is_success = true
    @recipe = Recipe.find_by(id: collection[0].recipe_id)

    ActiveRecord::Base.transaction do
      if @recipe.ingredient.empty?
        @exsting_ingredients = false
      else
        @exsting_ingredients = @recipe.ingredient
      end
      @exsting_ingredients.destroy_all if @exsting_ingredients
    
      collection.each do |result|
        is_success = false unless result.save
      end
      #バリデーションエラーがあったときは例外を発生させてロールバックさせる
      raise ActiveRecord::RecordInvalid unless is_success
    end
    
    rescue
      puts 'エラー'
    ensure
      return is_success
  end
  
  #レコードが存在するか確認するメソッド
  def persisted?
    false
  end
  
end