use Mix.Config

host = "10.252.28.105"

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :ret, RetWeb.Endpoint,
  url: [scheme: "https", host: host, port: 4000],
  static_url: [scheme: "https", host: host, port: 4000],
  https: [
    port: 4000,
    otp_app: :ret,
    keyfile: "#{System.get_env("PWD")}/priv/dev-ssl.key",
    certfile: "#{System.get_env("PWD")}/priv/dev-ssl.cert"
  ],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  secret_key_base: "txlMOtlaY5x3crvOCko4uV5PM29ul3zGo1oBGNO3cDXx+7GHLKqt0gR9qzgThxb5",
  allowed_origins: ["*"],
  watchers: [
    node: [
      "node_modules/brunch/bin/brunch",
      "watch",
      "--stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# command from your terminal:
#
#     openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout priv/server.key -out priv/server.pem
#
# The `http:` config above can be replaced with:
#
#     https: [port: 4000, keyfile: "priv/server.key", certfile: "priv/server.pem"],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :ret, RetWeb.Endpoint,
  # static_url: [scheme: "https", host: "assets-prod.reticulum.io", port: 443],
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/ret_web/views/.*(ex)$},
      ~r{lib/ret_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

env_db_host = "#{System.get_env("DB_HOST")}"

# Configure your database
config :ret, Ret.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "ret_dev",
  hostname: if(env_db_host == "", do: "localhost", else: env_db_host),
  template: "template0",
  pool_size: 10

config :ret, RetWeb.Plugs.HeaderAuthorization,
  header_name: "x-ret-admin-access-key",
  header_value: "admin-only"

# Allow any origin for API access in dev
config :cors_plug, origin: ["*"]

config :ret,
  upload_encryption_key: "a8dedeb57adafa7821027d546f016efef5a501bd",
  farspark_signature_key:
    "248cf801c4f5d6fd70c1b0dfea8dedeb57adafa7821027d546f016efef5a501bd8168c8479d33b466199d0ac68c71bb71b68c27537102a63cd70776aa83bca76",
  farspark_signature_salt:
    "da914bb89e332b2a815a667875584d067b698fe1f6f5c61d98384dc74d2ed85b67eea0a51325afb9d9c7d798f4bbbd630102a261e152aceb13d9469b02da6b31",
  farspark_host: "https://farspark-dev.reticulum.io"

config :ret, Ret.PageOriginWarmer,
  page_origin: "https://#{host}:8080",
  insecure_ssl: true

config :ret, Ret.MediaResolver,
  giphy_api_key: nil,
  deviantart_client_id: nil,
  deviantart_client_secret: nil,
  imgur_mashape_api_key: nil,
  imgur_client_id: nil,
  google_poly_api_key: nil,
  sketchfab_api_key: nil,
  ytdl_host: "http://localhost:9191"

config :ret, Ret.Storage,
  storage_path: "storage/dev",
  ttl: 60 * 60 * 24

asset_hosts =
  "https://localhost:4000 https://localhost:8080 https://#{host}:4000 https://#{host}:8080 https://asset-bundles-dev.reticulum.io https://asset-bundles-prod.reticulum.io https://farspark-prod.reticulum.io https://farspark-dev.reticulum.io"

websocket_hosts =
  "https://localhost:4000 https://localhost:8080 wss://localhost:4000 https://#{host}:4000 https://#{host}:8080 wss://#{
    host
  }:4000 wss://#{host}:8080 wss://dev-janus.reticulum.io wss://prod-janus.reticulum.io"

config :secure_headers, SecureHeaders,
  secure_headers: [
    config: [
      content_security_policy:
        "default-src 'none'; script-src 'self' #{asset_hosts} https://cdn.rawgit.com https://aframe.io 'unsafe-eval'; worker-src 'self' blob:; font-src 'self' https://fonts.googleapis.com https://fonts.gstatic.com https://cdn.aframe.io #{
          asset_hosts
        }; style-src 'self' https://fonts.googleapis.com #{asset_hosts} 'unsafe-inline'; connect-src 'self' https://sentry.prod.mozaws.net https://dpdb.webvr.rocks #{
          asset_hosts
        } #{websocket_hosts} https://cdn.aframe.io https://www.mozilla.org data: blob:; img-src 'self' #{asset_hosts} https://cdn.aframe.io data: blob:; media-src 'self' #{
          asset_hosts
        } data: blob:; frame-src 'self'; frame-ancestors 'self'; base-uri 'none'; form-action 'self';"
    ]
  ]

config :cors_plug, origin: &RetWeb.Endpoint.get_cors_origins/0

config :ret, Ret.Mailer, adapter: Bamboo.LocalAdapter

config :ret, RetWeb.Email, from: "info@hubs-mail.com"

config :ret, Ret.Guardian,
  issuer: "ret",
  secret_key: "47iqPEdWcfE7xRnyaxKDLt9OGEtkQG3SycHBEMOuT2qARmoESnhc76IgCUjaQIwX",
  ttl: {12, :weeks}

config :web_push_encryption, :vapid_details,
  subject: "mailto:admin@mozilla.com",
  public_key: "BAb03820kHYuqIvtP6QuCKZRshvv_zp5eDtqkuwCUAxASBZMQbFZXzv8kjYOuLGF16A3k8qYnIN10_4asB-Aw7w",
  private_key: "w76tXh1d3RBdVQ5eINevXRwW6Ow6uRcBa8tBDOXfmxM"

config :sentry,
  environment_name: :dev,
  json_library: Poison,
  included_environments: [],
  tags: %{
    env: "dev"
  }
