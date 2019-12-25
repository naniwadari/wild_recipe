class IngredientCollection
  #recipes/editビューから送られてきたデータを配列に入れて処理するためのクラス
  #クラスをモデル化することでモデルが持つメソッドを利用できるようにしている
  
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  INGREDIENT_NUM = 5 #同時に作成する材料の数
  attr_accessor :collection #作成した材料モデルが格納される仮属性
  
  #初期化メソッド
  def initialize(attributes = [], recipe_id)
    #レシピＩＤを指定
    @recipe = Recipe.find_by(id: recipe_id)
    #attributesに値が入っていればcollectionに材料データを入れ込んだ配列を代入する
    if attributes.present?
      #nameとamountがどちらも空であればvalueをnilにする
      self.collection = attributes.map do |value|
        if value[:name].present? && value[:amount].present?
          @recipe.ingredient.build(
            name: value[:name],
            amount: value[:amount]
            )
        end
      end
      #配列の要素がnilなら削除する
      self.collection.delete_if{|value| value.nil?}
      #配列の要素が材料数未満なら空の材料データを入れる
      if self.collection.count <= INGREDIENT_NUM
        rotation = INGREDIENT_NUM - self.collection.count
        rotation.times do
          self.collection.push( @recipe.ingredient.build )
        end
      end
      #上で代入した材料データにナンバーを割り振る
      self.collection.each_with_index do |value, i|
        value.number = "#{ (i + 1) }"
      end
    #attributesが定義されていないかorデータが空なら、外キー以外は空の材料データをNUM個作る
    else
      self.collection = INGREDIENT_NUM.times.map{ @recipe.ingredient.build }
    end
  end
  
  def save
    is_success = true
    ActiveRecord::Base.transaction do
      collection.each do |result|
        recipe = Recipe.find_by(id: result.recipe_id)
        ingre = recipe.ingredient.find_by(number: result.number)
        #同ナンバーを持つ材料を書き換え
        if ingre
          ingre.update(name: result.name)
          ingre.update(amount: result.amount)
          is_success = false unless ingre.save
        else
          #バリデーションをかけたい場合はsave、そうでなければsave!(強制)
          is_success = false unless result.save
        end
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