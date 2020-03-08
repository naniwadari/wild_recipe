ActiveAdmin.register Impression do
	#変更を許可する項目の設定
  permit_params :user_id, :recipe_id, :comment
  
  #ユーザー作成の中身を設定
  form do |f|
    f.inputs "新規レシピ" do
    	f.input :user_id
    	f.input :recipe_id
      f.input :comment
    end
    f.actions
  end
end
