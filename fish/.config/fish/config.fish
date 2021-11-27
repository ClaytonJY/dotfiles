if status is-interactive

    # starship.rs
    starship init fish | source


end

# pyenv
status is-login; and pyenv init --path | source
status is-interactive; and pyenv init - | source
