#/bash/sh

woomer --monitor $(niri msg focused-output | head -n 1 | awk '{print $NF}' | sed s/\(// | sed s/\)//)
