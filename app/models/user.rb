class User < ActiveRecord::Base
  rolify
  validates_presence_of :name, :balance
  validates_uniqueness_of :email
  validates :balance, :numericality => { :greater_than_or_equal_to => 0 }

  has_many :payments
  has_many :withdrawals
  has_many :payment_methods
  has_many :identities

  def self.create_with_omniauth(auth)
    create do |user|
      user.name = auth['info']['name'] || ""
      user.email = auth['info']['email'] || ""
      user.balance = 0.0
      user.change_role_to(:customer)
      user.active = true
    end
  end

  def self.find_by_email(email)
    User.where(email: email).first
  end

  def self.find_by_uid(uid)
    User.where(uid: uid).first
  end

  def is_any_admin?
    return true if self.super_admin? or self.admin?
    false
  end

  def super_admin?
    return true if self.has_role? :super_admin
    false
  end

  def admin?
    return true if self.has_role? :admin
    false
  end

  def customer?
    return true if self.has_role? :customer
    false
  end

  def locked?
    return true if self.active == false
    false    
  end

  def unlocked?
    return true if self.active == true
    false    
  end

  def activate!
    self.active = true
    self.save
  end

  def deactivate!
    self.active = false
    self.save
  end
  

  def role_name
    return "Super Admin" if self.super_admin?
    return "Admin" if self.admin?
    return "User" if self.customer?
  end

  def active_string
    return "Yes" if self.active?
    "No"
  end

  def change_role_to(role)
    self.roles = []
    self.add_role(role)
  end

  def send_money_to(user, amount)
    Payment.create_with_amount(current_user, user, amount)
  end

  def debit_from_balance(amount)
    self.balance -= amount
  end

  def add_to_balance(amount)
    self.balance += amount
  end

  def all_account_activity
    activity = []

    self.payments.last(5).each { |p| activity << p }
    self.withdrawals.last(5).each { |w| activity << w }

    activity.sort_by! { |t| t.created_at }
    activity.reverse
  end

end
