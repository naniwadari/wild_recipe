#CarrierWaveの設定呼び出し
require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

#画像名に日本語が使えるようにする
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

#保存先の分岐
CarrierWave.configure do |config|
	if Rails.env.production?
		config.storage = :fog
		config.fog_provider = 'fog/aws'
		config.fog_directory = 'wildrecipe'
		config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/wildrecipe'
		config.fog_public = false
		config.fog_credentials = {
			#AWS S3用の設定
			provider: 'AWS',
			region: 'ap-northeast-1',
			#環境変数で管理
			aws_access_key_id: Rails.application.secrets[:AWS_ACCESS_KEY_ID],
			aws_secret_access_key: Rails.application.secrets[:AWS_SECRET_ACCESS_KEY]
		}
	else
		#開発環境はlocalに保存
		config.storage :file
		config.enable_processing = false if Rails.env.test? #テスト環境なら処理をスキップ
	end
end