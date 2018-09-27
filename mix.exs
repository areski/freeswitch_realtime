defmodule FSRealtime.Mixfile do
  use Mix.Project

  def project do
    [
      app: :fs_realtime,
      version: "0.9.2",
      elixir: "~> 1.7.3",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [mod: {FSRealtime, []}, extra_applications: [:logger]]
  end

  # Dependencies
  defp deps do
    [
      {:ex_doc, "~> 0.19.1", only: :dev},
      {:distillery, "~> 2.0.10"},
      # {:sqlitex, path: "../sqlitex"},
      {:sqlitex, "~> 1.4.3"},
      {:ecto, "~> 2.2.10"},
      {:postgrex, ">= 0.0.0"},
      {:logger_file_backend, "0.0.10"},
      {:instream, "~> 0.18.0"},
      {:swab, github: "crownedgrouse/swab", branch: "master"},
      # {:timex, "~> 3.1.9"},
      # {:timex_ecto, "~> 3.0.5"},
      # {:tzdata, "~> 0.5.11"}
      {:mix_test_watch, "~> 0.9.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 0.10.2", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false}
      # {:dogma, "~> 0.1", only: :dev},
    ]
  end

  defp description, do: "Collect and push channels information from FreeSWITCH Sqlite to InfluxDB"

  defp package do
    [
      name: :fs_realtime,
      license_file: "LICENSE",
      external_dependencies: [],
      maintainers: ["Areski Belaid"],
      vendor: "Areski Belaid",
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/areski/freeswitch_realtime",
        "Homepage" => "https://github.com/areski/freeswitch_realtime"
      }
    ]
  end
end
