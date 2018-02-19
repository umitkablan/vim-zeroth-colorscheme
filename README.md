vim-zeroth-colorscheme
======================

# Overview

Zeroth Color Scheme (ZCS) is a vim utility plugin to help you manage your colorscheme files which are stored online somewhere at github, bitbucket or plain http://www.vim.org/scripts/. You do not need a pathogen-like system to manage such very limited (mostly only one colors/* file) files. The idea came to me when it feels unnecessary to have repo definitions for each colorscheme I want to try. With ZCS, you gain:

  - Avoid unnecessary repo lines in your `vimrc` file - only include `'umitkablan/vim-zeroth-colorscheme'` and it will provide you many *not-yet-installed* but *very accessible* colorschemes.
  - Easy accessible with tab completion - download & load & see instantly
  - Automatic loading of the last scheme you used
  - [TODO] Update colorscheme on every load without user's explicit care
  - [TODO] Colorscheme grouping/naming for your selection and browsing ease

Although Vundle/Plug addons are really helpful for managing plugins they are so heavy to orchestrate colorschemes, yet to treat colorscheme files as plugins is overkill. We need to treat those differently by easing the browse/locate also utilizing their repo nature.

With ZCS you do not have to manage your colorschemes as plugins - trying a new color is easy as writing its name and watching it downloads before it is applied. Since colorschemes are *light* plugins they all could be hidden behind a utility plugin like ZCS that they could benefit general colorscheme mechanisms while easing the accessibility from user's perspective.

# Installation

Using a package manager like [Plug](https://github.com/junegunn/vim-plug), add this line into `vimrc` file:

```vim
Plug 'umitkablan/vim-zeroth-colorscheme'
```

# Usage

`:ZerothCS` command will provide tab-completion list of colorschemes - installed or not. When selected colorscheme is not installed, it will be downloaded and applied automatically.

The last used scheme will be loaded when you start Vim next time (saving you another line to care). If you still don't want that feature, just disable it by `let g:zerothcs_autostart = 0`.

ZCS has many colorscheme definitions embedded - either as git repository or plain web resource. If your selection is a pluggable repo then it will download it to ZCS repo directory and add it to `rtp` path. ZCS repo directory defaults to `$HOME/.vim/zerothcs_colors` but it could be configured via `g:zerothcs_colors_repodir` variable. It will be created by default if doesn't exist on startup.

If your colorscheme is not pluggable then it is a plain `*.vim` file and it is downloaded default to `$HOME/.vim` directory. It could be changed via `g:zerothcs_colors_path` variable.

`:ZerothCS` command also supports `<user>/<repo>` style arguments. Then it will load the repository from `g:zerothcs_default_git_repo/<user>/<repo>` - `g:zerothcs_default_git_repo` defaults to `https://github.com`. Note that after downloading and adding it to `rtp`, ZCS will promt for the actual scheme name - the name you pass to `:colorscheme` command. This name could not be known in advance.

# How It Works

When you load ZCS a configuration file is also loaded which will have colorscheme lines with accompanying data like where they are located at. ZCS will help you try out those skins fast.

