if status is-login
    pyenv init --path | source
end

if status is-interactive

    starship init fish | source

    pyenv init - | source

end

# Created by `pipx` on 2023-02-11 05:40:43
set PATH $PATH /home/claytonjy/.local/bin
