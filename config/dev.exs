use Mix.Config

# Memcached test cache
config :nebulex_memcached_adapter, NebulexMemcachedAdapter.Cache,
  #version_generator: Nebulex.Version.Timestamp,
  pools: [
    primary: [
      hostname: "localhost",
      port: 11211
    ],
    secondary: [
      hostname: "127.0.0.1",
      port: 11211,
      pool_size: 2
    ]
  ]
