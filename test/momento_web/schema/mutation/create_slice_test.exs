defmodule MomentoWeb.Schema.Mutation.CreateSliceTest do
  use MomentoWeb.ConnCase, async: true

  @query """
  mutation($url: String!, $start_time: Int!, $end_time: Int!, $title: String!, $tags: String!) {
    createSlice(start_time: $start_time, end_time: $end_time, url: $url, title: $title, tags: $tags) {
      errors{
        key message
      }
      slice{
        start_time
        end_time
        title
        tags{
          name
        }
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
      end_time: 105,
      title: "YO, a title",
      tags: "tag1, tag2"
    }

    response =
      post(conn, "/api", %{
        query: @query,
        variables: slice
      })

    assert %{
             "data" => %{
               "createSlice" => data
             }
           } = json_response(response, 200)

    assert is_nil(data["errors"])

    assert %{
             "end_time" => slice.end_time,
             "start_time" => slice.start_time,
             "title" => slice.title,
             "tags" => [%{"name" => "tag1"}, %{"name" => "tag2"}]
           } == data["slice"]

    assert length(data["slice"]["tags"]) == 2
  end

  test "Fails to create when duration is invalid" do
    user = Factory.create_user()
    conn = put_auth_header(build_conn(), user)

    slice = %{
      url: "youtube.com/test",
      end_time: 90,
      start_time: 90,
      title: "",
      tags: ""
    }

    response =
      post(conn, "/api", %{
        query: @query,
        variables: slice
      })

    assert %{
             "data" => %{
               "createSlice" => data
             }
           } = json_response(response, 200)

    assert is_list(data["errors"])
    assert length(data["errors"]) > 0
    assert is_nil(data["slice"])
  end

  def put_auth_header(conn, user) do
    token = MomentoWeb.Authentication.sign(user)
    put_req_header(conn, "authorization", "Bearer " <> token)
  end
end
