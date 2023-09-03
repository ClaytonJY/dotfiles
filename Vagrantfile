Vagrant.configure("2") do |config|

  config.vm.box = "debian/bookworm64"

  config.vm.provider "virtualbox" do |vb|

    vb.memory = "1024"

  end

  config.vm.provision "shell", inline: <<-SHELL

    # install nix
    apt-get update && apt-get install -y curl git
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

    # setup user
    useradd -ms /bin/bash claytonjy
    cp -pr /home/vagrant/.ssh /home/claytonjy
    chown -R claytonjy:claytonjy /home/claytonjy
    echo "claytonjy ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

    # run home-manager bootstrap commands as user
    sudo -u claytonjy -i bash <<'EOF'

      # move files
      cd /vagrant
      mkdir -p ~/.config/home-manager
      cp -r flake.nix flake.lock home.nix git poetry ~/.config/home-manager

      # bootstrap home-manager
      mkdir -p ~/.local/state/nix/profiles
      nix run home-manager/master -- switch

      # change shell to fish
      echo $(which fish) | sudo tee -a /etc/shells
      sudo chsh -s $(which fish) "$USER"

      # install poetry w/ pipx
      pipx install poetry
EOF

  SHELL

  VAGRANT_COMMAND = ARGV[0]
  if VAGRANT_COMMAND == "ssh"
    config.ssh.username = 'claytonjy'
  end
end
