defmodule CatuumApi.CatsController do
  use CatuumApi.Web, :controller

  def index(conn, _) do
    cat = CatuumApi.Cat.random

    conn
    |> put_resp_content_type(cat.content_type)
    |> send_file(200, cat.path)
  end
end