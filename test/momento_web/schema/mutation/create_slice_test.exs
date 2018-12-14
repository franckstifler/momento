defmodule MomentoWeb.Schema.Mutation.CreateSliceTest do
  use MomentoWeb.ConnCase, async: true

  @query """
  mutation($url: String!, $start_time: Int!, $end_time: Int!) {
    createSlice(start_time: $start_time, end_time: $end_time, url: $url) {
      end_time
      start_time
      video {
        url
      }
    }
  }
  """

  test "create a slice for a logged in user" do
    user = Factory.create_user()
    conn = put_auth_header(build_conn(), user)

    slice = %{
      url: "youtube.com/testvideo",
      start_time: 100,
      end_time: 105
    }

    response =
      post(conn, "/api", %{
        query: @query,
        variables: slice
      })

    assert %{
             "data" => %{
               "createSlice" => %{
                 "video" => %{
                   "url" => slice.url
                 },
                 "end_time" => slice.end_time,
                 "start_time" => slice.start_time
               }
             }
           } == json_response(response, 200)
  end

  def put_auth_header(conn, user) do
    token = MomentoWeb.Authentication.sign(user)
    put_req_header(conn, "authorization", "Bearer " <> token)
  end
end
