#!/bin/bash
#
# Bash completion for aliases, via vendored complete-alias (complete_alias.sh).
#
# complete-alias expands each alias to its underlying command and delegates to
# that command's own completion (branches for `gco`, push flags for `gsta`,
# etc.). It works for any tool, not just git, and auto-discovers every alias.
#
# Note: complete-alias evaluates command substitutions in an alias body while
# building the completion line, so a `$(...)` alias runs that substitution on
# each <TAB>. We wire every alias regardless and observe behavior.

# Ensure git's completion is loaded so `complete -p git` exists for git aliases.
if ! declare -f _get_comp_words_by_ref &>/dev/null; then
    for _gcf in \
        /usr/share/bash-completion/completions/git \
        /usr/local/share/bash-completion/completions/git \
        /etc/bash_completion.d/git; do
        [[ -f "$_gcf" ]] && { source "$_gcf"; break; }
    done
    unset _gcf
fi

# Load the complete-alias engine (defines _complete_alias).
source "$HOME/customize/complete_alias.sh" || return

# Wire completion for every defined alias — no filtering.
complete -F _complete_alias "${!BASH_ALIASES[@]}"
