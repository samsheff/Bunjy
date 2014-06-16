class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:locked, :new, :create]
  before_filter :ensure_correct_user!, except: [:locked, :new, :create]
  before_filter :active_account!, except: [:new, :create]

  def index
    @user = current_user
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def new
  end

  def create
  user_data = secure_params
  user_data[:balance] = BigDecimal.new("0.0")
  user = User.create(user_data)

  if user && user.change_role_to!(:customer)
    session[:user_id] = user.id
    @current_user = user
    redirect_to user_path(user)
  else
    redirect_to new_user_path, notice: "There was an error creating this account"
  end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      respond_to do |format|
        format.html { redirect_to @user }
        format.json { render :json => @user }
      end      
    else
      respond_to do |format|
        format.html
        format.json { render json: { error: "There was an error updating the User" } }
      end      
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end    
  end

  def locked
  end

  private
  def secure_params
    params.require(:user).permit(:email, :name, :password)
  end

  def ensure_correct_user!
    unless current_user and current_user.id == params[:id].to_i
      redirect_to root_url, :alert => "Access denied"
    end
  end
end
