class UsersController < ApplicationController
  def index
    render json: User.select([:id, :email]).take(10), status: :ok
  end
end
