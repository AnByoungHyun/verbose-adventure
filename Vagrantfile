# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  config.vm.define "gw1" do |gw1|
    gw1.vm.hostname = "gateway1"
    gw1.vm.provider "virtualbox" do |vb|
      vb.name = "gateway1"
      vb.cpus = 2
      vb.memory = 2048
    end
    gw1.vm.network "public_network"  # DHCP
    gw1.vm.network "private_network", ip: "192.168.123.254", virtualbox__intnet: true
    gw1.vm.provision "shell", inline: <<-SCRIPT
      sudo ip route delete default via 10.0.2.2 dev enp0s3
      sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
      sudo sysctl -p
      sudo iptables -t nat -A POSTROUTING -s 192.168.123.10 -o enp0s8 -j LOG --log-prefix='[MASQ] '
      sudo iptables -t nat -A POSTROUTING -s 192.168.123.10 -o enp0s8 -j MASQUERADE
    SCRIPT
  end

  config.vm.define "dock_reg" do |dock_reg|
    dock_reg.vm.hostname = "docker-registry"
    dock_reg.vm.provider "virtualbox" do |vb|
      vb.name = "docker-registry"
      vb.cpus = 2
      vb.memory = 2048
    end
    dock_reg.vm.network "private_network", ip: "192.168.123.10", virtualbox__intnet: true
    dock_reg.vm.network "private_network", ip: "192.168.223.10", virtualbox__intnet: true
    dock_reg.vm.provision "shell", inline: <<-SCRIPT
      sudo ip route delete default via 10.0.2.2 dev enp0s3
      sudo ip route add default via 192.168.123.254 dev enp0s8
      sudo apt-get update -y
      sudo apt-get install -y ca-certificates curl gnupg
      sudo install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      sudo chmod a+r /etc/apt/keyrings/docker.gpg
      echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update -y
      sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      sudo usermod -a -G docker vagrant
    SCRIPT
  end

  config.vm.define "docker" do |docker|
    docker.vm.hostname = "docker"
    docker.vm.provider "virtualbox" do |vb|
      vb.name = "docker"
      vb.cpus = 2
      vb.memory = 2048
    end
    docker.vm.network "private_network", ip: "192.168.223.20", virtualbox__intnet: true
    docker.vm.provision "shell", inline: <<-SCRIPT
      sudo ip route delete default via 10.0.2.2 dev enp0s3
      sudo ip route add default via 192.168.223.254 dev enp0s8
      sudo apt-get update -y
      sudo apt-get install -y ca-certificates curl gnupg
        sudo install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      sudo chmod a+r /etc/apt/keyrings/docker.gpg
      echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update -y
      sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      sudo usermod -a -G docker vagrant
    SCRIPT
  end

  config.vm.define "gw2" do |gw2|
    gw2.vm.hostname = "gateway2"
    gw2.vm.provider "virtualbox" do |vb|
      vb.name = "gateway2"
      vb.cpus = 2
      vb.memory = 2048
    end
    gw2.vm.network "private_network", ip: "192.168.223.254", virtualbox__intnet: true
    gw2.vm.network "public_network"
    gw2.vm.provision "shell", inline: <<-SCRIPT
      sudo ip route delete default via 10.0.2.2 dev enp0s3
      sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
      sudo sysctl -p
      sudo iptables -t nat -A POSTROUTING -s 192.168.223.20 -o enp0s9 -j LOG --log-prefix='[MASQ] '
      sudo iptables -t nat -A POSTROUTING -s 192.168.223.20 -o enp0s9 -j MASQUERADE
    SCRIPT
  end

end
