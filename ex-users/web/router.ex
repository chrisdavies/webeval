defmodule ExUsers.Router do
  use ExUsers.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExUsers do
    pipe_through :browser # Use the default browser stack

    get "/users", UsersController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExUsers do
  #   pipe_through :api
  # end
end
