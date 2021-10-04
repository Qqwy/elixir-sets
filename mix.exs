defmodule Sets.Mixfile do
  use Mix.Project

  def project do
    [
      app: :sets,
      version: "0.1.0",
      elixir: "~> 1.3",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      name: "Sets",
      description: description(),
      source_url: "https://github.com/Qqwy/elixir-sets",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:ex_doc, "~> 0.14", only: :dev},

      {:fun_land, "~> 0.10.0"},
      {:insertable, "~> 1.0.0"},
      {:extractable, "~> 1.0.0"}
    ]
  end

  defp description do
    """
    Well-structured Sets for Elixir, offering a common interface with multiple implementations with varying performance guarantees that can be switched in your configuration.
    """
  end

  defp package() do
    [
      name: :sets,
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Qqwy/Wiebe-Marten Wijnja"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/Qqwy/elixir-sets"}
    ]
  end


end
