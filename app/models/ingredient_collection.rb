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
    #attributesに値が入っていればcollectionに配列を代入する
    if attributes.present?
      self.collection = attributes.map do |value|
        @recipe.ingredient.build(
          name: value[:name],
          amount: value[:amount] #,
          #number: value[:number]
        )
      end
    #attributesが定義されていないかorデータが空なら、外キー以外は空の材料データをNUM個作る
    else
      self.collection = INGREDIENT_NUM.times.map{ @recipe.ingredient.new }
    end
  end
  
  def save
    is_success = true
    ActiveRecord::Base.transaction do
      collection.each do |result|
        #バリデーションをかけたい場合はsave、そうでなければsave!(強制)
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