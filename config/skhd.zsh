function paneable() {
  local window_info=$(yabai -m query --windows --window)
  IFS=',' read -r app title pid <<< $(echo $window_info | jq -r '[.app, .title, .pid] | join(",")')

  if [[ "$app" == "kitty" ]] || ( [[ "$app" == "Alacritty" || "$app" == "WezTerm" ]] && [[ "$title" == "LazyVim" ]] ) || [[ "$title" == "Zellij"* ]] || (ps -p $pid | grep -q "zellij"); then
    return 0
  else
    return 1
  fi
}
