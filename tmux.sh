
open-tmux-panes-args() {
  local leader=""
  local comm=""

  [[ $# -gt 0 ]] || return

  while [[ $# -gt 0 ]]; do
    tmux split-window -l 1 -t "$TMUX_PANE" "$1"
    leader="${leader:-"$(tmux display-message -p "#{pane_id}")"}"
    shift
  done

  tmux break-pane -t "$TMUX_PANE"

  tmux select-window -t "$leader"
  tmux select-pane -t "$leader"
  tmux select-layout main-vertical >/dev/null
  tmux set-window-option synchronize-panes on >/dev/null
}

open-tmux-panes() {
  local jobs=()

  # slurp stdin first
  mapfile -t jobs
  open-tmux-panes-args "${jobs[@]}"
}

