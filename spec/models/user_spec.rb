require 'spec_helper'

describe User do
  it "has a default balance of zero" do
    expect build(:user).balance == 0.0
  end

  it "is active by default" do
    expect build(:user).active? == true
  end

  it "can be locked" do
    locked_user = build(:user)
    locked_user.active = false

    expect locked_user.locked? == true
  end

  it "can change roles" do
    user = build(:user)
    user.change_role_to(:customer)
    user.has_role?(:customer).should == true

    user.change_role_to(:admin)
    user.has_role?(:admin).should == true
    user.has_role?(:customer).should == false
  end

  it "can login with a username or password" do
    user = create(:user)
    User.login_with_email("dan@druff.com", "testtest").should == user
  end

  it "can find records with an email" do
    user = create(:user)
    User.find_by_email("dan@druff.com").should == user
  end

  it "can find and create records with an email from omniauth provider" do
    user = create(:user)
    auth = { 'info' => { 'email' => 'dan@druff.com', 'name' => 'Dan Druff' } }
    User.find_or_create_with_omniauth(auth).should == user

    auth['info']['email'] = "jonny@test.com"
    auth['info']['name'] = "Jonny Test"
    new_user = User.find_or_create_with_omniauth(auth)
    new_user.should_not == nil
    new_user.should be_a User
    new_user.email.should == "jonny@test.com"
  end

  it "knows if a user has a password" do
    user = build(:user)
    user.social_only?.should == false
  end

  it "knows if the user is an admin or superadmin" do
    user = build(:user)
    user.is_any_admin?.should == false
    user.change_role_to(:admin)
    user.is_any_admin?.should == true 
    user.change_role_to(:super_admin)
    user.is_any_admin?.should == true 
  end

  it "knows if the user is a superadmin" do
    super_admin = build(:user)
    super_admin.change_role_to :super_admin

    super_admin.super_admin?.should == true
    super_admin.customer?.should == false
  end

  it "knows if the user is an admin" do
    admin = build(:user)
    admin.change_role_to :admin

    admin.admin?.should == true
    admin.customer?.should == false
  end

  it "knows if the user is a customer" do
    user = build(:user)
    user.change_role_to :customer

    user.admin?.should == false
    user.customer?.should == true
  end

  it "Activates and deactivates user accounts" do
    user = build(:user)
    user.active?.should == true
    user.deactivate!
    user.active?.should == false
    user.locked?.should == true
  end

  it "knows the names of the possible roles" do
    user = build(:user)

    user.change_role_to(:customer)
    user.role_name.should == "User"

    user.change_role_to(:admin)
    user.role_name.should == "Admin"

    user.change_role_to(:super_admin)
    user.role_name.should == "Super Admin"
  end

  it "makes a string with account status" do
    user = build(:user)
    user.active_string.should == "Yes"
    user.deactivate!
    user.active_string.should == "No"
  end

  it "adds money to a balance" do
    user = build(:user)
    user.balance += 10.0
    user.add_to_balance(10.0)
    user.balance.should == 20.0
    user.balance.should_not == 0.0
    user.balance.should_not == 10.0
  end

  it "debits money from a balance" do
    user = build(:user)
    user.balance = 10.0
    user.balance -= 5.0
    user.debit_from_balance(5.0)
    user.balance.should == 0.0
    user.balance.should_not == 5.0
    user.balance.should_not == 10.0
  end

  it "Has Account Activity" do
    user = create(:user)
    5.times { user.payments << create(:payment) }
    5.times { user.withdrawals << create(:withdrawal) }
    activity = user.all_account_activity
    
    activity.should be_a Array
    activity.length.should == 10
  end
end
