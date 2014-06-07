class WithdrawalsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :active_account!

  def show
    @user = current_user
  end

  def new
    @user = current_user
  end

  def create
    if secure_params[:method_id] == "new"
      redirect_to '/payment_methods/new'   
    else
      payment_method = PaymentMethod.find(secure_params[:method_id])
      withdrawal = Withdrawal.create_with_amount(current_user,
                                            secure_params[:amount],
                                            payment_method)
      if withdrawal
        redirect_to new_withdrawal_path, notice: "Withdrawal Successful! Please allow 3-5 Business days for the money to appear in your account"
      else
        redirect_to new_withdrawal_path, notice: "There was an Error Withdrawing Funds"
      end
    end
  end

  private

  def secure_params
    params.require(:payment).permit(:to_email, :amount, :method_id)
  end

end

