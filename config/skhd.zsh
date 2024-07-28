function paneable() {
  local window_info=$(yabai -m query --windows --window)
  IFS=',' read -r app title pid <<< $(echo $window_info | jq -r '[.app, .title, .pid] | join(",")')

  if [[ "$app" == "kitty" ]] || ( [[ "$app" == "Alacritty" || "$app" == "WezTerm" ]] && [[ "$title" == "LazyVim" ]] ) || [[ "$title" == "Zellij"* ]] || (ps -p $pid | grep -q "zellij"); then
    return 0
  else
    return 1
  fi
}

function current_app_next_space() {
  local current_window=$(yabai -m query --windows --window)
  local current_app=$(echo $current_window | jq -r '.app')
  local current_space=$(echo $current_window | jq -r '.space')
  local app_spaces=(${(f)"$(yabai -m query --windows | jq -r ".[] | select(.app==\"$current_app\") | .space" | sort -n | uniq)"})

  if [[ ${#app_spaces} -le 1 ]]; then
    local next_space=$current_space
  else
    local current_index=${app_spaces[(i)$current_space]}

    if [[ $current_index -gt ${#app_spaces} ]]; then
      local next_space=$app_spaces[1]
    else
      local next_index=$(( (current_index % ${#app_spaces}) + 1 ))
      local next_space=$app_spaces[$next_index]
    fi
  fi

  local next_space_label=$(yabai -m query --spaces --space $next_space | jq -r '.label | .[-1:]')
  echo $next_space_label
}
