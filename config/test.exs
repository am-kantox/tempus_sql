import Config

config :tempus_sql, Tempus.SQL.Repo, database: "tempus_sql_test"

if System.get_env("GITHUB_ACTIONS") do
  config :tempus_sql, Tempus.SQL.Repo,
    hostname: "localhost",
    username: "postgres",
    password: "postgres"
end

config :logger, level: :error
