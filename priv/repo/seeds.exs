# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Momento.Repo.insert!(%Momento.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Momento.Repo

Repo.insert!(%Momento.Accounts.User{email: "franck@test.com", password_hash: "test", username: "franckstifler"})
Repo.insert!(%Momento.Media.Video{url: "https://www.youtube.com/watch?v=d1hWvGRT720.com"})
