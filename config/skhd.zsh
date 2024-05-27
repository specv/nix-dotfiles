function in_zellij() {
  local window=$(yabai -m query --windows --window)
  local app=$(echo "$window" | jq -r '.app')
  local title=$(echo "$window" | jq -r '.title')

  if [[ "$app" == "Alacritty" && "$title" == "Zellij"* ]]; then
    return 0
  else
    return 1
  fi
}
