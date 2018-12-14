defmodule MomentoWeb.Context do
  @behaviour Plug

  import Plug.Conn

  alias Momento.Accounts

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    IO.inspect [context: context]
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the auth header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
        {:ok, data} <- MomentoWeb.Authentication.verify(token),
         %{} = user <- get_user(data) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end

  defp get_user(%{id: id}) do
    Accounts.get_user(id)
  end
end
