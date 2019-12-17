require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WildRecipe
  class Application < Rails::Application
    config.load_defaults 5.1
    config.time_zone = "Tokyo"
    config.active_record.default_timezone = :local
    #デフォルトのlocaleを日本語(:ja)にする
    config.i18n.default_locale = :ja
    #i18nの複数ロケールファイルが読み込まれるようにpathを通す
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]
    #active_adminのheroku用設定
    config.assets.precompile += %w[ admin/active_admin.scss admin/active_admin.js]
    #認証トークンをremoteフォームに埋め込む(javascript無効の対策)
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
  
  
end
