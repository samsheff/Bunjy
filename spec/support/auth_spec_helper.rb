module AuthSpecHelper
  def log_in
    request.session[:user_id] = create(:user).id
  end

  def log_out
    request.session[:user_id] = nil
  end

  def current_user
    User.find(request.session[:user_id])
  end
end
