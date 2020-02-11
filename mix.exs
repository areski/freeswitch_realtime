defmodule FSRealtime.Mixfile do
  use Mix.Project

  def project do
    [
      app: :fs_realtime,
      version: "1.0.2",
      elixir: "> 1.9.0",
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
      {:ex_doc, "~> 0.21.3", only: :dev},
      {:distillery, "~> 2.1.1"},
      # {:sqlitex, path: "../sqlitex"},
      {:sqlitex, "~> 1.7.0"},
      {:ecto, "~> 3.3.2"},
      {:ecto_sql, "~> 3.3.3"},
      {:postgrex, ">= 0.0.0"},
      {:logger_file_backend, "0.0.11"},
      {:instream, "~> 0.22.0"},
      {:swab, github: "crownedgrouse/swab", branch: "master"},
      # {:timex, "~> 3.1.9"},
      # {:timex_ecto, "~> 3.0.5"},
      # {:tzdata, "~> 0.5.11"}
      {:mix_test_watch, "~> 1.0.2", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.2.2", only: [:dev, :test], runtime: false},
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
