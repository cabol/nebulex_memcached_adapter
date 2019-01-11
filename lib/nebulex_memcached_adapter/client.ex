defmodule NebulexMemcachedAdapter.Client do
  # Memcached Client Wrapper
  @moduledoc false

  @spec command(Nebulex.Cache.t(), fun, [term]) :: any | no_return
  def command(cache, fun, args) do
    apply(Memcache, fun, [get_conn(cache) | args])
  end

  ## Private Functions

  defp get_conn(cache) do
    index = rem(System.unique_integer([:positive]), cache.__pool_size__)
    :"#{cache}_memcached_#{index}"
  end
end
