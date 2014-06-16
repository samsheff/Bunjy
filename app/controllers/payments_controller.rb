class PaymentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :active_account!  

  def index
    @user = current_user
    @transactions = current_user.all_account_activity
    respond_to do |format|
      format.html
      format.json { render json: @transactions }
    end    
  end
  def show
    @user = current_user
    @method = Payment.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @method }
    end    
  end

  def new
    @user = current_user
  end

  def create
    if secure_params[:method_id] == "new"
      redirect_to '/payment_methods/new'   
    else
      recipient = User.find_by_email(secure_params[:to_email])
      unless recipient
        redirect_to '/payments/new', notice: "That person isn't on Bunjy yet! Once they Create their account, come back and try again"
      else
        payment_method = PaymentMethod.find(secure_params[:method_id])
        payment = Payment.create_with_amount(current_user, recipient,
                                           secure_params[:amount],
                                           payment_method)
        if payment
          respond_to do |format|
            format.html { redirect_to payment_path(payment) }
            format.json { render json: payment }
          end
        else
          redirect_to '/payments/new', notice: payment || "There was an Error Sending this Payment"
        end
      end
    end
  end

  private

  def secure_params
    params.require(:payment).permit(:to_email, :amount, :method_id)
  end

end

