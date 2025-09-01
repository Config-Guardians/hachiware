[
  import_deps: [:ash_postgres, :ash_json_api, :ash, :reactor, :phoenix],
  inputs: ["*.{ex,exs}", "{config,lib,test}/**/*.{ex,exs}"],
  plugins: [Spark.Formatter]
]
