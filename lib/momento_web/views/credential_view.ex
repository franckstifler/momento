defmodule MomentoWeb.CredentialView do
    use MomentoWeb, :view

    def render("credential.json", %{error: error}) do
        %{
            errors: %{
                msg: error
            }
        }
    end
end