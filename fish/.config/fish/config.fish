if status is-login
    pyenv init --path | source
end

if status is-interactive

    starship init fish | source

    pyenv init - | source

end
