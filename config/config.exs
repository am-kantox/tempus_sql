import Config

config :tempus_sql, Tempus.SQL.Repo,
  hostname: "localhost",
  username: "elixir_dev",
  password: "alchemist",
  pool: Ecto.Adapters.SQL.Sandbox

config :tempus_sql, ecto_repos: [Tempus.SQL.Repo]

if File.exists?(Path.join(~w|config #{Mix.env()}.exs|)),
  do: import_config("#{Mix.env()}.exs")
