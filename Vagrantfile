require "readline"

Vagrant.configure("2") do |config|
  # Functional helper to read inputs.
  def input(prompt="", newline=false)
    prompt += "\n" if newline
    Readline.readline(prompt, true).squeeze(" ").strip
  end

  # Get what setup we are going to use.
  booting = (["up", "reload", "provisioning"]).include?(ARGV[0])
  # currently, only 2 nodes are supported
  nodes = 2
=begin
  if booting
    answer = ""
    while (answer != "2" && answer != "3") do
        answer = input "How many nodes? (2|3): "
        answer = answer.upcase
    end
    nodes = answer
  end
=end

  # Provisioning all
  config.vm.provision :shell, path: "provisioning/bootstrap-all.sh"

  # Node 1
  config.vm.define "node1" do |node1|
    # Variables.
    ip          = "10.0.0.101"
    project     = "node1.mysqlcloud"
    mem = "1024"

    # Provisioning
    if (nodes == "2")
        provisioningroot = "/vagrant/node2of2"
        config.vm.provision :shell, path: "provisioning/node2of2/bootstrap.sh", args: [provisioningroot]
    elsif (nodes == "3")
        provisioningroot = "/vagrant/node2of3"
        config.vm.provision :shell, path: "provisioning/node2of3/bootstrap.sh", args: [provisioningroot]
    end

    # Base Box
    node1.vm.box     = "chef/ubuntu-14.04"

    # Networking
    node1.vm.network "private_network", ip: ip
    node1.ssh.forward_agent = true
    node1.vm.hostname = "#{project}.local"

    # NFS Mount
    node1.vm.synced_folder ".", "/vagrant", type: "nfs"

    # Memory
    node1.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", mem]
    end
  end

  # Node 2
  config.vm.define "node2" do |node2|
    # Variables.
    ip          = "10.0.0.102"
    project     = "node2.mysqlcloud"
    mem = "1024"

    # Provisioning
    if (nodes == "2")
        provisioningroot = "/vagrant/node2of2"
        config.vm.provision :shell, path: "provisioning/node2of2/bootstrap.sh", args: [provisioningroot]
    elsif (nodes == "3")
        provisioningroot = "/vagrant/node2of3"
        config.vm.provision :shell, path: "provisioning/node2of3/bootstrap.sh", args: [provisioningroot]
    end

    # Base Box
    node2.vm.box     = "chef/ubuntu-14.04"

    # Networking
    node2.vm.network "private_network", ip: ip
    node2.ssh.forward_agent = true
    node2.vm.hostname = "#{project}.local"

    # NFS Mount
    node2.vm.synced_folder ".", "/vagrant", type: "nfs"

    # Memory
    node2.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", mem]
    end
  end

  # Node 3
  if (nodes == "3")
    config.vm.define "node3" do |node3|
      # Variables.
      ip          = "10.0.0.103"
      project     = "node3.mysqlcloud"
      mem = "1024"

      # Provisioning
      provisioningroot = "/vagrant/node2of3"
      config.vm.provision :shell, path: "provisioning/node3of3/bootstrap.sh", args: [provisioningroot]

      # Base Box
      node3.vm.box     = "chef/ubuntu-14.04"

      # Networking
      node3.vm.network "private_network", ip: ip
      node3.ssh.forward_agent = true
      node3.vm.hostname = "#{project}.local"

      # NFS Mount
      node3.vm.synced_folder ".", "/vagrant", type: "nfs"

      # Memory
      node3.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", mem]
      end
    end
  end
end
