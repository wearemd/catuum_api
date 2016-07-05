defmodule CatuumApi.Router do
  use CatuumApi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", CatuumApi do
    pipe_through :browser

    get "/cats", CatsController, :index
  end
end
