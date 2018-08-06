#!/usr/bin/env zsh
#
# Set environment variables to be used in all shell invocations.


export EDITOR='nvim'
export PAGER='less -XF'

export PATH="${HOME}/.bin:${PATH}"
if [[ -f '/usr/local/bin/brew' ]]; then
    export PATH="/usr/local/bin:/usr/local/sbin:${PATH}"

    # See https://github.com/Homebrew/homebrew-core/issues/24792
    export PATH="/usr/local/opt/python@2/libexec/bin:${PATH}"
fi

function {
    local ZSHENV_PRIVATE="${HOME}/.zshenv-private"
    if [[ -f "${ZSHENV_PRIVATE}" ]]; then
        source "${ZSHENV_PRIVATE}"
    fi
}
