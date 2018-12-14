defmodule Factory do

  def create_user() do
    int = :erlang.unique_integer([:positive, :monotonic])
    params = %{
      username: "Person #{int}",
      email: "fake-#{int}@example.com",
      password: "super-secret",
    }

    %Momento.Accounts.User{}
    |> Momento.Accounts.User.changeset(params)
    |> Momento.Repo.insert!
  end
end
