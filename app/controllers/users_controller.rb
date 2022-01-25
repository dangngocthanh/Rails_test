class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    p params['user']['password']
    cost = ActiveModel::SecurePassword.min_cost ?
             BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
    password = BCrypt::Password.create(params['user']['password'], cost: cost)

    @user = User.new(email: params['user']['email'],name: params['user']['name'], password_digest: password)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)

  end
end
