defmodule CatuumApi do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(CatuumApi.Endpoint, []),
      # Start redis repo
      worker(CatuumApi.RedisRepo, [:catuum_api_redis]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CatuumApi.Supervisor]
    res  = Supervisor.start_link(children, opts)

    # At start run the import
    CatuumApi.Cat.import

    res
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CatuumApi.Endpoint.config_change(changed, removed)
    :ok
  end
end
