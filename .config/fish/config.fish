fish_add_path ~/.local/bin /opt/homebrew/bin /opt/homebrew/sbin

if status is-interactive
    # Commands to run in interactive sessions can go here
end
abbr -a s 'sesh connect "$(sesh list -i | gum filter --limit 1 --placeholder '\''Pick a sesh'\'' --prompt='\''⚡'\'')"'
abbr -a zad 'ls -d */ | xargs -I {} zoxide add {}'
if type -q zoxide
    zoxide init fish | source
end
if type -q starship
    starship init fish | source
end
