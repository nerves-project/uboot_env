defmodule UBootEnv.MixProject do
  use Mix.Project

  def project do
    [
      app: :uboot_env,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      docs: docs(),
      deps: deps()
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
      {:fwup, "~> 0.3.0", only: [:test]},
      {:ex_doc, "~> 0.18", only: [:dev, :test], runtime: false}
    ]
  end

  defp docs do
    [extras: ["README.md"], main: "readme"]
  end

  defp description do
    """
    Read and write UBoot environment variables
    """
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{
        "Github" => "https://github.com/nerves-project/uboot_env"
      }
    ]
  end
end
