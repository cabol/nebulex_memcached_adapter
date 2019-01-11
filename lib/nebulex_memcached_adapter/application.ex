
defmodule NebulexMemcachedAdapter.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      NebulexMemcachedAdapter.Cache,
    ]

    opts = [strategy: :one_for_one, name: PartitionedCache.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
