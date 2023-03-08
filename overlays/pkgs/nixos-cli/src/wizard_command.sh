echo "# this file is located in 'src/wizard_command.sh'"
echo "# code for 'nixos wizard' goes here"
echo "# you can edit it freely and regenerate (it will not be overwritten)"
inspect_args

info "Choose your disk"
disk="$(ask_disk)"
show $disk

task "ls -lah && pwd"
info "Cool!"

info "What's it gonna be?"
val=$(ask ready set go)
show $val

info "What is your name?"
name="$(ask)"
show $name

pause 
pause "Again people"

if confirm --warn Scary?; then
  echo "You think scary"
else
  echo "You dunna want it"
fi

ask "one" "two" "three"

warn "Well? What it gunna be?"
if confirm; then
  show you agreed
else
  show you did not agree
fi

pause "Hold it!"