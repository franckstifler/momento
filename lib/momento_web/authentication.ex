defmodule MomentoWeb.Authentication do
  @salt "a very salty salt"

  def sign(data) do
    Phoenix.Token.sign(MomentoWeb.Endpoint, @salt, data)
  end

  def verify(token) do
    Phoenix.Token.verify(MomentoWeb.Endpoint, @salt, token, max_age: 365 * 54 * 36)
  end
end
