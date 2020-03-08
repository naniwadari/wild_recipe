ActiveAdmin.register Recipe do
	#変更を許可する項目の設定
  permit_params :user_id, :name, :comment, :release, :image
  
  #ユーザー作成の中身を設定
  form do |f|
    f.inputs "新規レシピ" do
			f.input :user_id
			f.input :name
      f.input :comment
      f.input :release
      f.input :image
    end
    f.actions
  end
end
