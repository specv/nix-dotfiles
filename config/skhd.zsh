function paneable() {
  local window_info=$(yabai -m query --windows --window)
  IFS=',' read -r app title pid <<< $(echo $window_info | jq -r '[.app, .title, .pid] | join(",")')

  if [[ "$app" == "kitty" ]] || ( [[ "$app" == "Alacritty" || "$app" == "WezTerm" ]] && [[ "$title" == "LazyVim" ]] ) || [[ "$title" == "Zellij"* ]] || (ps -p $pid | grep -q "zellij"); then
    return 0
  else
    return 1
  fi
}

function focus_window_of_app() {
  local direction=$1
  local current_window=$(yabai -m query --windows --window)
  local current_app=$(echo $current_window | jq -r '.app')
  local current_id=$(echo $current_window | jq -r '.id')
  local app_window_ids=(${(f)"$(yabai -m query --windows | jq -r ".[] | select(.app==\"$current_app\") | .id" | sort -n)"})

  if [[ ${#app_window_ids} -le 1 ]]; then
    return
  fi

  local current_index=${app_window_ids[(i)$current_id]}
  if [[ $direction == "next" ]]; then
    local next_index=$(( (current_index % ${#app_window_ids}) + 1 ))
  else
    local next_index=$(( ((current_index - 2 + ${#app_window_ids}) % ${#app_window_ids}) + 1 ))
  fi

  yabai -m window --focus ${app_window_ids[$next_index]}
}
