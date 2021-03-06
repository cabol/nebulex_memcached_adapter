defmodule NebulexMemcachedAdapter.MixProject do
  use Mix.Project

  @version "1.0.0-dev"

  def project do
    [
      app: :nebulex_memcached_adapter,
      version: @version,
      elixir: "~> 1.6",
      deps: deps(),

      # Docs
      name: "NebulexMemcachedAdapter",
      docs: docs(),

      # Testing
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

      # Dialyzer
      dialyzer: dialyzer(),

      # Hex
      package: package(),
      description: "Nebulex adapter for Memcached"
    ]
  end

  def application do
    [
      extra_applications: [],
      mod: {NebulexMemcachedAdapter.Application, []}
    ]
  end

  defp deps do
    [
      {:memcachex, "~> 0.4"},

      # This is because the adapter tests need some support modules and shared
      # tests from nebulex dependency, and the hex dependency doesn't include
      # the test folder. Hence, to run the tests it is necessary to fetch
      # nebulex dependency directly from GH.
      {:nebulex, nebulex_opts()},

      # Test
      {:excoveralls, "~> 0.6", only: :test},
      {:benchee, "~> 0.13", optional: true, only: :dev},
      {:benchee_html, "~> 0.5", optional: true, only: :dev},

      # Code Analysis
      {:dialyxir, "~> 0.5", optional: true, only: [:dev, :test], runtime: false},
      {:credo, "~> 0.10", optional: true, only: [:dev, :test]},

      # Docs
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:inch_ex, "~> 0.5", only: :docs}
    ]
  end

  defp nebulex_opts do
    if System.get_env("NBX_TEST") do
      [github: "cabol/nebulex", tag: "v1.0.1"]
    else
      "~> 1.0"
    end
  end

  defp package do
    [
      name: :nebulex_memcached_adapter,
      maintainers: ["Carlos Bolanos"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/cabol/nebulex_memcached_adapter"}
    ]
  end

  defp docs do
    [
      main: "NebulexMemcachedAdapter",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/nebulex_memcached_adapter",
      source_url: "https://github.com/cabol/nebulex_memcached_adapter"
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:nebulex, :shards, :mix, :eex],
      flags: [
        :unmatched_returns,
        :error_handling,
        :race_conditions,
        :no_opaque,
        :unknown,
        :no_return
      ]
    ]
  end
end
