ActiveAdmin.register User do
  #変更を許可する項目の設定
  permit_params :name, :email, :password , :password_confirmation
  
  #ユーザー作成の中身を設定
  form do |f|
    f.inputs "新規ユーザー" do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
  
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :email, :password_digest, :admin
  #
  # or
  #
  # permit_params do
  # permitted = [:name, :email, :password_digest, :admin]
  # permitted << :other if params[:action] == 'create' && current_user.admin?
  # permitted
  # end
end
