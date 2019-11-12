defmodule Rumbl.MixProject do
  use Mix.Project

  def project do
    [
      app: :rumbl,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [
        :logger,
        :runtime_tools,
        :comeonin,
      ],
      mod: {Rumbl.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:info_sys, in_umbrella: true},
      {:phoenix, "~> 1.4.10"},
      {:ecto_sql, "~> 3.1"},
      {:jason, "~> 1.0"},
      {:postgrex, ">= 0.0.0"},
      {:argon2_elixir, "~> 2.0"},
      {:dialyxir, "~> 0.5.1", only: [:dev]},
    ]
  end
end
