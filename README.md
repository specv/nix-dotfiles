# nix-dotfiles


## Key bindings


### Mac

- `cmd-f1`: Mirror the main display

- `alt-f1`: Open up display settings

- `right_shift`: Switch input method

- `cmd+ctrl-space`: Emoji picker


### Global

- `cmd+ctrl-t`:  New Terminal(alacritty), or `ctrl-n`(multiple app icons) if alacritty activated

- `cmd+ctrl-n`:  Show / Hide nvALT

### Karabiner


### Terminal

- `ctrl-c`: Shell interrupt

- `ctrl-f`: Accept input

- `ctrl-g`: Accept input & Execute

- `ctrl-r`: FZF history

- `ctrl-s`: FZF ripgrep-all (search)

- `ctrl-t`: FZF ripgrep (target)

- `ctrl-o`: FZF open file (open)

- `ctrl-p`: FZF cd (path)

- `ctrl-k`: Previous history

- `ctrl-j`: Next history


### Alacritty

- `ctrl+shift-space`: Vi Mode

- `cmd-f`: Search

#### hints

- `ctrl+shift-u`: open [u]rl

- `ctrl+shift-w`: copy [w]ord

- `ctrl+shift-s`: copy [s]ymbol(email, hash, ip ...)

- `ctrl+shift-r`: copy [r]ow


### Vim

- `Z Z` `:wq` `:x`: save and exit

- `Z Q` `:q!`: exit without save


### LazyGit

[Lazygit Keybindings](https://github.com/jesseduffield/lazygit/blob/master/docs/keybindings/Keybindings_en.md)

#### diff panel

- `ctrl-o`: copy selected text to clipboard

- `ctrl-d` `ctrl-u`: page up page down

- `,`: move to previous page

- `.`: move to next page

- `<`: move to top

- `>`: move to bottom

- `h`: move to previous hunk

- `l`: move to next hunk


### Chrome

- `cmd-[` `cmd-left`: go back

- `cmd-]` `cmd-right`: go forward


#### Surfingkeys


##### Leader keys

- `o`:

- `g`:

#### 

- `q`:

- `f`:

##### search

##### tab

- `R`:

- `E`:

- `>>`:

- `<<`:


##### Page

- `yg`: capture current page

- `yG`: capture current scroll page

- `yS`: capture current scroll target

- `yv`: yank element

- `yc`:

- `;pm`: mardown preview


##### Zoom

- `zi`:

- `zo`:

- `zr`:

- `zv`: visual element


##### window

##### bookmark

- `ab`:

##### marks

- `om`: check out all the vim-like marks you have created

##### pass through

- `alt-s`: disable surfingkeys to use site's built-in keyboard shortcuts

- `alt-i`: pass through (temporarily disable, press `esc` to enable)

- `p`: ephemeral pass through (temporarily disable, then enable after 1 second)



### Pycharm

#### Custom

- `cmd-,` + `d`: Go To Database Object


### Emacs readline

#### [Commands For Moving](https://www.gnu.org/software/bash/manual/html_node/Commands-For-Moving.html)

- `ctrl-a`: Move to the start of the current line

- `ctrl-e`: Move to the end of the line

- `ctrl-f`: Move forward a character

- `ctrl-b`: Move back a character

- `esc f` `alt-f` : Move forward to the end of the next word

- `esc b` `alt-b` : Move back to the start of the current or previous word


#### [Killing And Yanking](https://www.gnu.org/software/bash/manual/html_node/Commands-For-Killing.html)

- `ctrl-w`: Kill the word before cursor

- `esc d` `alt-d`: Kill the word after cursor

- `ctrl-k`: Kill the text from point to the end of the line

- `ctrl-u`: Kill backward from the cursor to the beginning of the current line

- `ctrl-y`: Restores the last item removed from the line (Yanks the item back to the line)

- `ctrl-h`: Backspace

- `ctrl-j`: Enter

- `ctrl-p`: Previous history

- `ctrl-n`: Next hisotry


#### Etc

- `fc`:     Fix command

- `alt-.`:  Insert last argument to the previous command (the last word of the previous history entry)

- `ctrl-v` `ctrl-x ctrl-e`: Invoke an editor on the current command line, and execute the result as shell commands

  - mysql:   `\e` `edit`

  - pry:     `edit`

  - ipython: `edit`
