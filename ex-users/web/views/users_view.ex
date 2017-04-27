defmodule ExUsers.UsersView do
  use ExUsers.Web, :view

  def render("index.json", %{users: users}) do
    Enum.map(users, &user_json/1)
  end

  defp user_json(user) do
    %{
      id: user.id,
      email: user.email,
    }
  end
end
