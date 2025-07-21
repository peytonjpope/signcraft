defmodule Signcraft.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SigncraftWeb.Telemetry,
      Signcraft.Repo,
      {DNSCluster, query: Application.get_env(:signcraft, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Signcraft.PubSub},
      # Start the Finch HTTP client for sending usernames
      {Finch, name: Signcraft.Finch},
      # Start a worker by calling: Signcraft.Worker.start_link(arg)
      # {Signcraft.Worker, arg},
      # Start to serve requests, typically the last entry
      SigncraftWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Signcraft.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SigncraftWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
