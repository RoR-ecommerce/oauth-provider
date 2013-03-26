class Api::V1::UsersController < Api::V1::ApiController
  authorize_resource! scope: "users.show", :only => [:show, :me]
  authorize_resource! scope: "users.create", :only => [:new, :create]
  authorize_resource! scope: "users.update", :only => [:edit, :update]
  authorize_resource! scope: "users.destroy", :only => [:destroy]

  before_filter :load_user, except: [:me, :new, :create]

  def me
    @user = User.find_by_email(params[:email])
    respond_with(@user)
  end

  def new
    @user = User.new
    respond_with(@user)
  end

  def create
    @user = User.create(params[:user])
    respond_with(@user)
  end

  def show
    respond_with(@user)
  end

  def edit
    respond_with(@user)
  end

  def update
    @user.update_attributes!(user_params)
    respond_with(@user)
  end

  def destroy
    @user.destroy
    respond_with(@user)
  end

  protected
    def user_params
      params.require(:user).permit(:email, :password)
    end

    def load_user
      @user = if params[:id]
                User.find(params[:id])
              else
                User.new(user_params)
              end
    end
end
