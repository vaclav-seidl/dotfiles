source /usr/share/cachyos-fish-config/cachyos-config.fish

set -l shared_aliases ~/.config/shell/aliases
if test -f $shared_aliases
    source $shared_aliases
end
