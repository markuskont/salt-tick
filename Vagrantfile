# vi: set ft=ruby :
MASTER_IP = '192.168.56.169'
# NOTE - building from git can take a lot of time and contain bugs
SALT = 'stable' # stable|git|daily|testing
# version to check out if using git
SALT_VERSION = "v2016.11.2"

INFLUX_IP = '192.168.56.160'

boxes = [
  {
    :name       => "influx",
    :mem        => "2048",
    :cpu        => "4",
    :ip         => INFLUX_IP,
    :image      => 'ubuntu/xenial64',
    :saltmaster => false,
    :saltenv    => 'DEVEL'
  },
  {
    :name       => "shipper-1",
    :mem        => "1024",
    :cpu        => "2",
    :ip         => "192.168.56.161",
    :image      => 'ubuntu/xenial64',
    :saltmaster => false,
    :saltenv    => 'DEVEL'
  },
  {
    :name       => "alerta",
    :mem        => "1024",
    :cpu        => "2",
    :ip         => "192.168.56.162",
    :image      => 'ubuntu/xenial64',
    :saltmaster => false,
    :saltenv    => 'DEVEL'
  },
  #{
  #  :name       => "shipper-2",
  #  :mem        => "512",
  #  :cpu        => "1",
  #  :ip         => "192.168.56.163",
  #  :image      => 'ubuntu/xenial64',
  #  :saltmaster => false,
  #  :saltenv    => 'TEST'
  #},
  {
    :name       => "saltmaster",
    :mem        => "512",
    :cpu        => "2",
    :ip         => MASTER_IP,
    :image      => "ubuntu/trusty64",
    :saltmaster => true
  }
]

Vagrant.configure(2) do |config|
  boxes.each do |opts|
    config.vm.define opts[:name] do |config|
      config.vm.box = opts[:image]
      config.vm.hostname = opts[:name]
      config.vm.network 'private_network',
        ip: opts[:ip]
      config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", opts[:mem]]
        v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]
      end
      config.vm.provision "shell",
        inline: "grep salt /etc/hosts || sudo echo \"#{MASTER_IP}\"  salt >> /etc/hosts"
      config.vm.provision "shell",
        inline: "grep influx /etc/hosts || sudo echo \"#{INFLUX_IP}\"  influx >> /etc/hosts"
      config.vm.provision :salt do |salt|
        salt.minion_config = "vagrant/config/minion"
        salt.masterless = false
        salt.run_highstate = false
        salt.install_type = SALT
        salt.install_master = opts[:saltmaster]
        if opts[:saltmaster] == true
          salt.master_config = "vagrant/config/master"
        end
      end
      config.vm.provision "shell", path: "./vagrant/scripts/devel_packages.sh"
      config.vm.provision "shell", path: "./vagrant/scripts/assign_roles.py"
      if opts[:saltmaster] == true
        config.vm.provision "shell", path: "./vagrant/scripts/winrepo.sh"
      else
        config.vm.provision "shell",
          inline: "sudo sed -i s/DEVEL/\"#{opts[:saltenv]}\"/g /etc/salt/minion && service salt-minion restart"
      end
    end
  end
end
