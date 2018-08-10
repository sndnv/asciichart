defmodule Asciichart.MixProject do
  use Mix.Project

  def project do
    [
      app: :asciichart,
      version: "1.0.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      # test coverage
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        qa: :test
      ],
      # docs
      name: "asciichart",
      source_url: "https://github.com/sndnv/asciichart",
      homepage_url: "https://github.com/sndnv/asciichart",
      docs: [
        main: "asciichart",
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
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:excoveralls, "~> 0.9.1", only: :test}
    ]
  end

  defp aliases do
    [
      build: ["deps.get", "clean", "format", "compile"],
      qa: ["build", "coveralls.html"]
    ]
  end
end
