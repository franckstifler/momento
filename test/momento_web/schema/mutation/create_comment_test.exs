defmodule MomentoWeb.Schema.Mutation.CreateComment do
  use MomentoWeb.ConnCase, async: true

  @query """
  mutation($comment: String!, $slice_id: Int!) {
    createComment(comment: $comment, slice_id: $slice_id) {
     errors {
       key message
     }
     comment {
       comment
     }
    }
  }
  """
  def put_auth_header(conn, user) do
    token = MomentoWeb.Authentication.sign(user)
    put_req_header(conn, "authorization", "Bearer " <> token)
  end

  test "create comment for connected user" do
    user = Factory.create_user()
    slice = Factory.create_slice()
    conn = put_auth_header(build_conn(), user)

    comment = %{
      comment: "test comment",
      slice_id: slice.id
    }

    response = post(conn, "/api", %{query: @query, variables: comment})

    assert %{
      "data" => %{
        "createComment" => data
      }
    } = json_response(response, 200)

    assert is_nil(data["errors"])
    assert data["comment"]["comment"] == comment.comment
  end
end
