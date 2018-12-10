defmodule MomentoWeb.Context do
  @behaviour Plug

  import Plug.Conn
  import Ecto.Query, only: [first: 1]

  alias Momento.{Repo, Accounts}

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the auth header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- authorize(token) do
      %{current_user: current_user}
    else
      _ -> %{}
    end
  end

  defp authorize(_token) do
    Accounts.User
    # |> where(token: ^token)
    |> first()
    |> Repo.one()
    |> case do
      nil -> {:error, "Invalid authorization token"}
      user -> {:ok, user}
    end
  end
end
