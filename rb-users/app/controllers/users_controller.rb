require 'open-uri'

class UsersController < ApplicationController
  def index
    render json: User.select([:id, :email]).take(10), status: :ok
  end

  def proxy
    result = open('http://127.0.0.1:8081/?ms=500').read
    render plain: result
  end
end
