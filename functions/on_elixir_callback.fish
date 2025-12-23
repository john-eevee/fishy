function on_elixir_callback --description "Actions to perform when entering an Elixir project directory"
  set -gx MIX_ENV test
  # Check if _build directory exists; if not, run mix deps.get
  if not test -d "_build"
      log -l info "_build directory not found. Running 'mix deps.get'..."
      mix deps.get
      log -l info "'mix deps.get' completed."
  end

  # Optionally, you can add more Elixir-specific setup here

end
