defmodule MomentoWeb.UserView do
  use MomentoWeb, :view
  alias MomentoWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      username: user.username}
  end

  def render("token.json", %{token: token}) do
    %{
      data: %{
        token: token
      }
    }
  end
end
