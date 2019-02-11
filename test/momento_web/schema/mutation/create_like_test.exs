defmodule MomentoWeb.Schema.Mutation.CreateLike do
  use MomentoWeb.ConnCase, async: true

  @query """
  mutation($slice_id: Int!) {
    createLike(slice_id: $slice_id) {
     errors {
       key message
     }
     like {
       sliceId
     }
    }
  }
  """
  def put_auth_header(conn, user) do
    token = MomentoWeb.Authentication.sign(user)
    put_req_header(conn, "authorization", "Bearer " <> token)
  end

  test "like a slice for connected user" do
    user = Factory.create_user()
    slice = Factory.create_slice()
    conn = put_auth_header(build_conn(), user)

    response = post(conn, "/api", %{query: @query, variables: %{slice_id: slice.id}})

    assert %{
             "data" => %{
               "createLike" => data
             }
           } = json_response(response, 200)

    assert is_nil(data["errors"])
    assert data["like"]["sliceId"] == slice.id
  end

  @query """
    mutation($slice_id: String!) {
      deleteLike(slice_id: $slice_id) {
        errors {
          message
        }
        like {
          sliceId
        }
      }
    }
  """
  test "Remove like from a liked slice" do
    user = Factory.create_user()
    slice = Factory.create_slice()
    conn = put_auth_header(build_conn(), user)

    Momento.Media.create_like(user, %{slice_id: slice.id})

    response = post(conn, "/api", %{query: @query, variables: %{slice_id: slice.id}})

    assert %{
             "data" => %{
               "deleteLike" => data
             }
           } = json_response(response, 200)

    assert is_nil(data["errors"])
    assert data["like"]["sliceId"] == slice.id
  end

  test "Should return error if the slice does not exists" do
    user = Factory.create_user()

    conn = put_auth_header(build_conn(), user)

    response = post(conn, "/api", %{query: @query, variables: %{slice_id: 10_000}})

    assert %{
             "data" => %{
               "deleteLike" => data,
             },
             "errors" => errors
           } = json_response(response, 200)

    assert length(errors) == 1
    assert is_nil(data)
  end
end
