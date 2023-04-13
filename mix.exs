defmodule TempusSql.MixProject do
  use Mix.Project

  @app :tempus_sql
  @version "0.1.0"

  def project do
    [
      app: @app,
      version: @version,
      name: "Tempus SQL",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      description: description(),
      package: package(),
      deps: deps(),
      aliases: aliases(),
      xref: [exclude: []],
      docs: docs(),
      dialyzer: [
        plt_file: {:no_warn, ".dialyzer/dialyzer.plt"},
        plt_add_deps: :transitive,
        plt_add_apps: [:nimble_options],
        list_unused_filters: true,
        ignore_warnings: ".dialyzer_ignore.exs"
      ]
    ]
  end

  def application, do: []

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tempus, "~> 0.9"},
      {:ecto_sql, "~> 3.0"},
      {:jason, "~> 1.0"},
      {:postgrex, "> 0.0.0"},
      # dev / test / ci
      {:credo, "~> 1.0", only: [:dev, :ci], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :ci], runtime: false},
      {:ex_doc, "~> 0.11", only: [:dev], runtime: false}
    ]
  end

  defp aliases do
    [
      test: ["ecto.drop --quiet", "ecto.create --quiet", "ecto.migrate --quiet", "test"],
      quality: ["format", "credo --strict", "dialyzer --unmatched_returns"],
      "quality.ci": [
        "format --check-formatted",
        "credo --strict",
        "dialyzer"
      ]
    ]
  end

  defp description do
    """
    Ecto support for `Tempus` library
    """
  end

  defp package do
    [
      name: @app,
      files: ~w|lib mix.exs README.md LICENSE|,
      maintainers: ["Aleksei Matiushkin"],
      licenses: ["Kantox LTD"],
      links: %{
        "GitHub" => "https://github.com/am-kantox/#{@app}",
        "Docs" => "https://hexdocs.pm/#{@app}"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/#{@app}",
      source_url: "https://github.com/am-kantox/#{@app}",
      extras: ~w[README.md],
      groups_for_modules: []
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "lib_dev", "test", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "lib_dev"]
  defp elixirc_paths(_), do: ["lib"]
end
