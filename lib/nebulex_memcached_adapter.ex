defmodule NebulexMemcachedAdapter do
  @moduledoc """
  Nebulex adapter for Memcached.

  For more information about the usage, check out `Nebulex.Cache` as well.
  """

  # Inherit default transaction implementation
  # use Nebulex.Adapter.Transaction

  # Provide Cache Implementation
  @behaviour Nebulex.Adapter
  # @behaviour Nebulex.Adapter.Queryable

  # alias Nebulex.Object
  # alias NebulexMemcachedAdapter.Client

  @default_pool_size System.schedulers_online()

  ## Adapter

  @impl true
  defmacro __before_compile__(env) do
    otp_app = Module.get_attribute(env.module, :otp_app)
    config = Module.get_attribute(env.module, :config)

    pool_size =
      if pools = Keyword.get(config, :pools) do
        Enum.reduce(pools, 0, fn {_, pool}, acc ->
          acc + Keyword.get(pool, :pool_size, @default_pool_size)
        end)
      else
        raise ArgumentError,
              "missing :pools configuration in " <>
                "config #{inspect(otp_app)}, #{inspect(env.module)}"
      end

    quote do
      def __pool_size__, do: unquote(pool_size)
    end
  end

  @impl true
  def init(opts) do
    cache = Keyword.fetch!(opts, :cache)

    children =
      opts
      |> Keyword.fetch!(:pools)
      |> Enum.reduce([], fn {_, pool}, acc ->
        acc ++ children(pool, cache, acc)
      end)

    {:ok, children}
  end

  defp children(pool, cache, acc) do
    offset = length(acc)
    pool_size = Keyword.get(pool, :pool_size, @default_pool_size)

    for i <- offset..(offset + pool_size - 1) do
      name = :"#{cache}_memcached_#{i}"
      Supervisor.child_spec({Memcache, [pool, [name: name]]}, id: {Memcache, i})
    end
  end
end
