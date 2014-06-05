class SessionsController < ApplicationController

  def new
    redirect_to '/auth/facebook' if params[:provider] == "facebook"
    redirect_to '/auth/google_oauth2' if params[:provider] == "google"
  end

  def create
    auth = request.env['omniauth.auth']
    # Find an identity here
    @identity = Identity.find_with_omniauth(auth)

    if @identity.nil?
      # If no identity was found, create a brand new one here
      @identity = Identity.create_with_omniauth(auth)
    end

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
        # The identity we found had a user associated with it so let's 
        # just log them in here
        self.current_user = @identity.user
        redirect_to user_path(current_user), notice: "Signed in!"
      else
        # No user associated with the identity so we need to create a new one
        unless @identity.user
          @identity.user = User.create_with_omniauth(auth)
          @identity.save
        end
        current_user = @identity.user
        redirect_to user_path(current_user), notice: "Signed in!"
      end
    end
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

end
