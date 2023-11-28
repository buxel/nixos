{ lib, writeShellApplication, curl, less, gnused, this }: (writeShellApplication {
  name = "yo";
  runtimeInputs = [ curl less gnused ];

  text = /* bash */ ''
    # comment
    echo "Yo ${this.lib.foo} this is a shell script" "$@" "<end-of-line>"
    pwd
  '';
}) // {
  meta = with lib; {
    description = "yo script";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
