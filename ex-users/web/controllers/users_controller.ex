defmodule ExUsers.UsersController do
  use ExUsers.Web, :controller

  alias ExUsers.User

  def index(conn, _params) do
    users = Repo.all(from u in User,
              limit: 10,
              select: map(u, [:id, :email]))
    render(conn, "index.json", users: users)
  end
end
