defmodule CatuumApi.CatsController do
  use CatuumApi.Web, :controller

  def index(conn, _) do
    cat = CatuumApi.Cat.random

    conn
    |> put_resp_content_type(cat.content_type)
    |> send_file(200, cat.path)
  end

  def count(conn, %{"count" => count}) do
    cats = CatuumApi.Cat.random(count)

    conn
    |> assign(:cats, cats)
    |> render("index.json")
  end
end