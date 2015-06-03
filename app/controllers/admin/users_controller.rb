class Admin::UsersController < ApplicationController

  before_filter :only_admin_access

  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

end