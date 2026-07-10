setopt PROMPT_SUBST

_branch_name() {
  local ref
  ref=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) \
    || ref=$(git rev-parse --short HEAD 2>/dev/null) \
    || return
  [[ -n $ref ]] && print -r -- "($ref)"
}

PROMPT='%F{blue}%~%f %F{yellow}$(_branch_name)%f
 ❯ '
