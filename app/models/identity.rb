class Identity < ActiveRecord::Base
  belongs_to :user

  def self.find_with_omniauth(auth)
    find_by(provider: auth['provider'], uid: auth['uid'])
  end

  def self.create_with_omniauth(auth)
    create(uid: auth['uid'], provider: auth['provider'])
  end

  def self.find_or_create_with_omniauth(auth)
    if identity = self.find_with_omniauth(auth)
      return identity
    else
      return self.create_with_omniauth(auth)
    end
  end
end
