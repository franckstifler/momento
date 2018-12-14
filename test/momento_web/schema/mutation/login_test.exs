defmodule MomentoWeb.Schema.Mutation.LoginTest do
  use MomentoWeb.ConnCase, async: true

  @query """
  mutation ($email: String!, $username: String!, $password: String!) {
    create_user(email: $email, password: $password, username: $username) {
      username
      email
    }
  }
  """
  test "creates a user" do
    user = %{email: "test@test.com", username: "test", password: "test"}

    response =
      post(build_conn(), "/api/graphiql", %{
        query: @query,
        variables: user
      })

    assert %{
             "data" => %{
               "create_user" => %{
                 "username" => user.username,
                 "email" => user.email
               }
             }
           } == json_response(response, 200)
  end

  @query """
  mutation($email: String!) {
    login(email: $email, password: "super-secret") {
      token
      user {
        email
      }
    }
  }
  """

  test "Returns a user token" do
    user = Factory.create_user()

    response =
      post(build_conn(), "/api/graphiql", %{
        query: @query,
        variables: %{
          email: user.email
        }
      })

    assert %{
             "data" => %{
               "login" => %{
                 "token" => token
               }
             }
           } = json_response(response, 200)
  end
end
