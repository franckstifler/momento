defmodule Momento.Auth do

  alias Momento.Repo
  alias Momento.Accounts.User

  def authenticate(email, password) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, :unauthorized, "Invalid username or password."}
      user -> check_password(user, password)
    end
  end

  defp check_password(user, password) do
    case Comeonin.Bcrypt.checkpw(password, user.password_hash) do
      true -> {:ok, user}
      false -> :error
    end
  end
end
