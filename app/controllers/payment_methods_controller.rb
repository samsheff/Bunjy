class PaymentMethodsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @methods = current_user.payment_methods
  end

  def edit
    @user = current_user
    @method = PaymentMethod.find(params[:id])
  end

  def update
    @user = current_user
    @method = PaymentMethod.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to @method
    else
      render :edit
    end
  end

  def show
    @user = current_user
    @method = PaymentMethod.find(params[:id])
  end

  def new
    @user = current_user
  end

  def create
    #secure_params[:direction] = secure_params[:direction].to_i
    payment_method = PaymentMethod.create(secure_params)
    redirect_to '/payment_methods/new', notice: "There was a problem saving this card. Quick Tip: It must be a debit card" if !payment_method || !payment_method.save_to_stripe
    current_user.payment_methods << payment_method
    redirect_to user_path(current_user) if current_user.save
  end

  private

  def secure_params
    params.require(:payment_method).permit(:email, :method_type, :name,
                                           :method_type, :stripe_token,
                                           :direction)
  end

end
