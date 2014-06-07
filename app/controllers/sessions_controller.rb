class SessionsController < ApplicationController

  def new
    redirect_to '/auth/facebook' if params[:provider] == "facebook"
    redirect_to '/auth/google_oauth2' if params[:provider] == "google"
  end

  def create
    auth = request.env['omniauth.auth']
    # Find an identity here
    @identity = Identity.find_or_create_with_omniauth(auth)
    @identity.user = User.find_or_create_with_omniauth(auth) unless @identity.user
    @identity.save

    if signed_in?
      if @identity.user == current_user
        # User is signed in so they are trying to link an identity with their
        # account. But we found the identity and the user associated with it 
        # is the current user. So the identity is already associated with 
        # this user. So let's display an error message.
        redirect_to user_path(current_user), notice: "Already linked that account!"
      else
        # The identity is not associated with the current_user so lets 
        # associate the identite
        @identity.user = current_user
        @identity.save
        redirect_to user_path(current_user), notice: "Successfully linked that account!"
      end
    else
      if @identity.user
        session[:user_id] = @identity.user.id
        redirect_to user_path(current_user), notice: "Signed in!"
      else
        redirect_to root_url, notice: "There was an error signing you in"
      end        
    end
  end

  def destroy
    end_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
end
