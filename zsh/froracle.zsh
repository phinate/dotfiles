# 🐸 froracle — a frog greets every new interactive shell.
#
# Speed-first: it calls the uv-managed CPython interpreter directly so there is
# no per-launch dependency resolution. Falls back to system python3 (the script
# is pure stdlib, so any Python 3.9+ works). It never breaks your shell: if the
# script or interpreter is missing, it silently does nothing.

# Where the oracle lives, and the fast interpreter to run it with.
export FRORACLE_HOME="${FRORACLE_HOME:-$HOME/Code/test/nothing}"
typeset -g _FRORACLE_PY="$HOME/.local/share/uv/python/cpython-3.13-macos-aarch64-none/bin/python3.13"

# Resolve a usable interpreter once, cheaply.
_froracle_python() {
  if [[ -x "$_FRORACLE_PY" ]]; then
    print -r -- "$_FRORACLE_PY"
  else
    command -v python3
  fi
}

# `froracle [args]` — consult the oracle by hand. No args = a full fortune.
froracle() {
  emulate -L zsh
  local script="$FRORACLE_HOME/froracle.py"
  [[ -f "$script" ]] || return 0
  local py; py="$(_froracle_python)"
  [[ -n "$py" ]] || return 0
  "$py" "$script" "$@"
}

# `pond [args]` — dive into the live terminal pond.
pond() {
  emulate -L zsh
  local script="$FRORACLE_HOME/pond.py"
  [[ -f "$script" ]] || { print -r -- "no pond at $script"; return 1; }
  local py; py="$(_froracle_python)"
  [[ -n "$py" ]] || return 1
  "$py" "$script" "$@"
}

# Greet on each new interactive shell (compact, fast, fault-tolerant).
if [[ -o interactive ]]; then
  froracle --greet 2>/dev/null
fi
