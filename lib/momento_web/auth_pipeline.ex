defmodule Momento.Guardian.AuthPipeline do
    use Guardian.Plug.Pipeline, otp_app: :momento,
                                module: Momento.Guardian,
                                error_handler: Momento.AuthErrorHandler

    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
end

defmodule Momento.AuthErrorHandler do
    import Plug.Conn

    def auth_error(conn, {type, reason}, _opts) do
        body = Poison.encode!(%{message: to_string(type)})
        send_resp(conn, 401, body)
    end
end