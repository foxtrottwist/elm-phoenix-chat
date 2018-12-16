use Mix.Config

config :vmeste, Vmeste.Repo,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  database: System.get_env("POSTGRES_DB"),
  hostname: System.get_env("DATABASE_HOST"),
  pool_size: 15

port = String.to_integer(System.get_env("PORT") || "8080")

config :vmeste, MyApp.Endpoint,
  http: [port: port],
  url: [host: System.get_env("HOSTNAME"), port: port],
  root: ".",
  secret_key_base: System.get_env("SECRET_KEY_BASE")
