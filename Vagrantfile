# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  #config.vm.box = "hashicorp/precise64"
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.provision :shell, path: "katanasetup.sh", privileged: false
    
  config.vm.network :forwarded_port, guest: 8010, host: 8010
  
  # mysql moved to port 3307 locally to avoid conflicts with existing local mysql instances
  config.vm.network :forwarded_port, guest: 3306, host: 3307
	
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
end
