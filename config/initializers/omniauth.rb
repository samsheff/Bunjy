Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "292495877591711", "f36677aa777a903962b8ca62997b36f1" if !Rails.env.production?
  provider :facebook, ENV['OMNIAUTH_PROVIDER_KEY'], ENV['OMNIAUTH_PROVIDER_SECRET'] if Rails.env.production?
end
