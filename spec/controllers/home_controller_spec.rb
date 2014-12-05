require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "redirects if logged in" do
      log_in
      get 'index'
      response.should redirect_to user_path current_user.id
    end
  end

end
