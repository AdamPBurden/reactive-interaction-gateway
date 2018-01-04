defmodule RigAuth.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rig_auth,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rig, in_umbrella: true},
      {:confex, "~> 3.3"},
      {:cowboy, "~> 1.0"},
      {:httpoison, "~> 0.13.0"},
      {:joken, "~> 1.4"},
      {:phoenix, "~> 1.3.0"},
      {:plug, "~> 1.4"},
      {:poison, "~> 2.0 or ~> 3.0"},
      {:stubr, "~> 1.5.0", only: :test},
    ]
  end
end