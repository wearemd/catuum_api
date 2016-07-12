defmodule CatuumApi.CatsView do
  use CatuumApi.Web, :view

  def render("index.json", %{cats: cats}) do
    cats
  end
end