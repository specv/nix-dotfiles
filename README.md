# nix-dotfiles


## Key bindings


### Global

- `cmd+ctrl-t`:  New Terminal(alacritty), or `ctrl-n` if alacritty activated

- `cmd+ctrl-n`:  Show / Hide nvALT


### Terminal

- `ctrl-c`: Shell interrupt

- `ctrl-f`: Accept input

- `ctrl-g`: Accept input & Execute

- `ctrl-r`: FZF history

- `ctrl-e`: FZF ripgrep (edit)

- `ctrl-o`: FZF open file (open)

- `ctrl-t`: FZF cd (target)

- `ctrl-k`: Previous history

- `ctrl-j`: Next history


### Vim


### Pycharm

#### Custom

- `cmd-,` + `d`: Go To Database Object


### Emacs readline

#### [Commands For Moving](https://www.gnu.org/software/bash/manual/html_node/Commands-For-Moving.html)

- `ctrl-a`: Move to the start of the current line

- `ctrl-e`: Move to the end of the line

- `ctrl-f`: Move forward a character

- `ctrl-b`: Move back a character

- `alt-f` : Move forward to the end of the next word

- `alt-b` : Move back to the start of the current or previous word


#### [Killing And Yanking](https://www.gnu.org/software/bash/manual/html_node/Commands-For-Killing.html)

- `ctrl-w`: Kill the word behind point

- `ctrl-k`: Kill the text from point to the end of the line

- `ctrl-u`: Kill backward from the cursor to the beginning of the current line

- `ctrl-h`: Backspace

- `ctrl-j`: Enter

- `ctrl-p`: Previous history

- `ctrl-n`: Next hisotry


#### etc

- `fc`:     Fix command

- `alt-.`:  Insert last argument to the previous command (the last word of the previous history entry)

- `ctrl-x ctrl-e`: Invoke an editor on the current command line, and execute the result as shell commands

  - mysql:   `\e` `edit`

  - pry:     `edit`

  - ipython: `edit`
