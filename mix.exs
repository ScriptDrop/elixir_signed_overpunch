defmodule SignedOverpunch.Mixfile do
  use Mix.Project

  def project do
    [
      app: :signed_overpunch,
      version: "0.1.2",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/ScriptDrop/elixir_signed_overpunch",
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application, do: [extra_applications: [:logger]]

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Package for converting strings using the signed overpunch format into integers."
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Derek Schneider"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ScriptDrop/elixir_signed_overpunch"}
    ]
  end
end
