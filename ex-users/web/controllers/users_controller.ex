defmodule ExUsers.UsersController do
  use ExUsers.Web, :controller

  alias ExUsers.User

  def index(conn, _params) do
    users = Repo.all(from u in User,
              limit: 10,
              select: map(u, [:id, :email]))
    render(conn, "index.json", users: users)
  end

  def proxy(conn, _params) do
    response = HTTPotion.get! "http://127.0.0.1:8081/api/sleep/?ms=500", [
      ibrowse: [max_sessions: 420, max_pipeline_size: 400]]

    case response do
      %HTTPotion.ErrorResponse{message: m} ->
        IO.puts "ERROR: " <> m
        conn
            |> put_resp_content_type("text/plain")
            |> send_resp(500, m)
      _ ->
        conn
            |> put_resp_content_type("text/plain")
            |> send_resp(200, response.body)
    end
  end
end
