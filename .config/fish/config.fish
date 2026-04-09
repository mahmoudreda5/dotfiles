fish_add_path ~/.local/bin

if status is-interactive
    # Commands to run in interactive sessions can go here
end
abbr -a s 'sesh connect "$(sesh list -i | gum filter --limit 1 --placeholder '\''Pick a sesh'\'' --prompt='\''⚡'\'')"'
abbr -a zad 'ls -d */ | xargs -I {} zoxide add {}'
starship init fish | source
