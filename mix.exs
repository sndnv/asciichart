defmodule Asciichart.MixProject do
  use Mix.Project

  def project do
    [
      app: :asciichart,
      version: "1.2.1-SNAPSHOT",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.json": :test,
        qa: :test
      ],
      docs: [
        main: "Asciichart",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:excoveralls, "~> 0.18.0", only: :test}
    ]
  end

  defp aliases do
    [
      build: ["deps.get", "clean", "format", "compile"],
      qa: ["build", "coveralls.html"]
    ]
  end

  def coverage do
    [
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.travis": :test,
        qa: :test
      ]
    ]
  end

  @github_url "https://github.com/sndnv/asciichart"

  def package do
    [
      name: :asciichart,
      description: "ASCII terminal line charts with no dependencies",
      files: ["lib", "mix.exs", "LICENSE", "README.md"],
      maintainers: ["Angel Sanadinov"],
      licenses: ["Apache 2.0"],
      links: %{
        "Github" => @github_url,
        "Ported from kroitor/asciichart" => "https://github.com/kroitor/asciichart"
      },
      source_url: @github_url,
      homepage_url: @github_url,
      docs: [
        main: "asciichart",
        extras: ["README.md"]
      ]
    ]
  end
end
