defmodule Momento.Schema.Helpers do


  def by_id(model, ids) do
    import Ecto.Query

    ids = Enum.uniq(ids)

    model
    |> where([m], m.id in ^ids)
    |> Momento.Repo.all()
    |> Map.new(&{&1.id, &1})
  end
end
