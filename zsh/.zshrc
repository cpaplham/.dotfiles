#!/usr/bin/env zsh
#
# Primary entry point for interactive shell invocation.


function __config_zsh {
    setopt NO_BEEP

    bindkey '^[[A' up-line-or-beginning-search
    bindkey '^[[B' down-line-or-beginning-search
}

function __config_oh_my_zsh {
    ZSH="${HOME}/.oh-my-zsh"
    ZSH_CUSTOM="${HOME}/.oh-my-zsh-custom"

    CASE_SENSITIVE='false'
    DISABLE_AUTO_UPDATE='true'
    DISABLE_UNTRACKED_FILES_DIRTY='true'
    ENABLE_CORRECTION='true'
    HYPHEN_INSENSITIVE='true'
    KEYTIMEOUT=1
    ZSH_DISABLE_COMPFIX='true'
    ZSH_DISABLE_COMPINIT='true'

    if [[ -n "$EMACS" ]]; then
        ZSH_THEME='philips'
    else
        ZSH_THEME='powerlevel9k/powerlevel9k'

        # TODO: Set prompt elements dynamically based on the width of the
        # terminal. At around 140 characters wide or greater, it's nicer to have
        # the vcs data on the left prompt, closer to the path.
        POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
            dir
            rbenv
            virtualenv
            root_indicator
        )
        POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
            status
            command_execution_time
            background_jobs
            vcs
        )
        POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'
        POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
        POWERLEVEL9K_SHORTEN_DELIMITER='"'
    fi

    plugins=(
        colored-man-pages
        docker
        encode64
        git
        git-extras
        pip
        python
        sudo
        virtualenv
        virtualenvwrapper
        wd
        zsh-syntax-highlighting
    )

    source "${ZSH}/oh-my-zsh.sh"
}

function __config_alias {
    alias lsvirtualenv='lsvirtualenv -b'
    alias p='parallel --will-cite'
    alias parallel='parallel --will-cite'
    alias v='nvim'
    alias vi='nvim'
    alias vim='nvim'
    alias vimdiff='nvim -d'
}

function __config_environ {
    # NOTE: Most environment configuration should be located in .zshenv -- this
    # function is solely for setting those environment variables specific to
    # TTYs.
    export TERM='xterm-256color'
}

function __config_private {
    local ZSHRC_PRIVATE="${HOME}/.zshrc-private"
    if [[ -f "$ZSHRC_PRIVATE" ]]; then
        source "$ZSHRC_PRIVATE"
    fi
}

__config_zsh
__config_oh_my_zsh
__config_alias
__config_environ
__config_private
