# Tmux Configuration Guide

## Keybindings Reference

### Prefix Keys
Both work as prefix:
- `Ctrl+b` (default)
- `Alt+Space`

### Pane Navigation (after prefix)
- `h` - move left
- `j` - move down
- `k` - move up
- `l` - move right

### Pane Splitting (after prefix)
- `v` or `|` or `%` - vertical split (side by side)
- `s` or `-` or `"` - horizontal split (top/bottom)

### Terminal Clear
- `Ctrl+;` - clears terminal (no prefix needed)

### Copy Mode (vi-style)
Enter copy mode with `prefix + [`
- `v` - start selection
- `Ctrl+v` - toggle rectangle selection
- `y` - copy selection and exit

## Settings Applied

| Setting | Value | Reason |
|---------|-------|--------|
| Status bar | top | Vim uses bottom |
| Base index | 1 | More intuitive than 0 |
| Mouse | on | Click to select panes |
| True color | on | Better color support |
| Vi mode | on | Vim-style copy mode |

## Plugins Installed
- `tpm` - Plugin manager
- `tmux-sensible` - Sensible defaults
- `vim-tmux-navigator` - Seamless vim/tmux navigation with Ctrl+h/j/k/l
- `catppuccin-tmux` - Theme (mocha flavor)
- `tmux-yank` - Better copy/paste

## Reload Config
```bash
tmux source-file ~/.config/tmux/tmux.conf
```

Or from inside tmux: `prefix + :` then type `source-file ~/.config/tmux/tmux.conf`
