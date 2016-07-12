defmodule CatuumApi.Endpoint do
  use Phoenix.Endpoint, otp_app: :catuum_api

  socket "/socket", CatuumApi.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :catuum_api, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

   # Serve cats from "uploads/" directory
  plug Plug.Static,
    at: "/uploads", from: "uploads/", gzip: false,
    headers: [
      {"access-control-allow-origin", "*"}
    ]

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_catuum_api_key",
    signing_salt: "+4AQYSFv"

  plug CORSPlug
  plug CatuumApi.Router
end
