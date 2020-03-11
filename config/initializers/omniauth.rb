Rails.application.config.middleware.use OmniAuth::Builder do
	provider :twitter, Rails.application.secrets.API_KEY, Rails.application.secrets.API_SECRET_KEY
end