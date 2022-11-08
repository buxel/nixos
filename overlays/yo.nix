{ lib, writeShellApplication, curl, less, gnused }: (writeShellApplication {
  name = "yo";
  runtimeInputs = [ curl less gnused ];

  text = /* bash */ ''
    # comment
    echo "Yo this is bash"
  '';
}) // {
  meta = with lib; {
    description = "yo script";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
