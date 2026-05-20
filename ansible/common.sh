Common command

Table of contents

1. Get IP address
2. Install remote desktop
3. Get DevOps source code
4. Run setup.sh
   4.1 Prepare secrets + .env
   4.2 Common errors


1. Get Virtual Machine IP Address
# On host machine (Ubuntu)
virsh domifaddr ub24-master  #ub24-master is name of VM

or ssh to vm then run:
ip link 
or
ip a  # ip addr

or install net-tools
ifconfig  | grep inet

2. Install xRDP for Remote desktop
sudo apt install xrdp -y

Add the xrdp user to the ssl-cert group for proper certificate access
sudo adduser xrdp ssl-cert

Configure Firewall: Allow RDP traffic through UFW
sudo ufw allow 3389/tcp
sudo ufw reload

sudo systemctl restart xrdp

3. Download DevOps source code 
   (to Virtual Machine (vm): using git or copy)

# In Master node (vm)
sudo apt install -y git   # Intall Git
#Clone source code
git clone https://bitbucket.org/seta-r1/ai-platform.git
cd ai-platform
git checkout devops-gitops/dev # branch name which hold DevOps source code

# Method 2: scp
# Copy DevOps code to Master node (from host machine or local machine)
scp -rp devops-gitops r1vn-auto4@192.168.1.225:~/
# this will copy whole folder devops-gitops/ to 192.168.1.225 machine; username is r1vn-auto4;
ip addr or ip link => for get IP address

4. Run setup.sh
4.1 Prepare secret files and .env files
devops-gitops/ansible/node-secrets.sh

Jenkins ?
ArgoCD

4.2 Errors CRLF
/usr/bin/env: ‘bash\r’: No such file or directory
/usr/bin/env: use -[v]S to pass options in shebang lines

=> Clone source in Linux vm or use dos2unix fix
sudo apt install -y dos2unix
dos2unix setup.sh  # and setup-node.sh, promote.sh

If you cloned source code in Windows => then copy and run on Linux vm

git config --global core.autocrlf false # Disable Git auto convert end of line format


5. Ansible 
ansible-vault create secret.yaml
ansible-vault show...

setup-worker-node.sh

Update IP addresses of worker nodes:
WORKERS="${WORKERS:-192.168.122.75 192.168.122.216}"
run 
./setup-worker-node.sh    # inside scripts/ folder in Host machine
  
 Enter SSH password (user / password when create Ubuntu VM)

If use same worker node user / password => run only once.

  Add new user to vm node:
  sudo useradd k8-wk1
  sudo passwd k8-wk1  # Set password; Same password for simple
  sudo usermod -aG sudo k8-wk1 # add user k8-wk1 to sudoers group
  sudo mkdir /home/k8-wk1
  sudo chown -R k8-wk1:k8-wk1 /home/k8-wk1
  sudo chmod 750 /home/k8-wk1


If chose different user / password => edit setup-worker-node.sh then run again.
SSH_USER="${SSH_USER:-k8-worker1}" to match target worken node.
or 
SSH_USER="${SSH_USER:-k8-worker2}"

Common errors:

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
[ERROR]: Task failed: Failed to connect to the host via ssh: Warning: Permanently added '192.168.122.216' (ED25519) to the list of known hosts.
k8-wk1@192.168.122.216: Permission denied (publickey,password).

fatal: [192.168.122.216]: UNREACHABLE! => {"changed": false, "msg": "Task failed: Failed to connect to the host via ssh: Warning: Permanently added '192.168.122.216' (ED25519) to the list of known hosts.\r\nk8-wk1@192.168.122.216: Permission denied (publickey,password).", "unreachable": true}

=> SSH issue => check SSH_Password in setup-worker-node.sh 
or use ssh key.

see add ssh publickey guide in openssh.sh
SSH_KEY config look like
SSH_KEY="${SSH_KEY:-}"
Default public file at ~/.ssh/id_rsa.pub


5.2 Error
[ERROR]: Task failed: Failed to create temporary directory. In some cases, you may have been able to authenticate and did not have permissions on the target directory. Consider changing the remote tmp path in ansible.cfg... `" ), exited with result 1
fatal: [192.168.122.216]: UNREACHABLE! => {"changed": false, "msg": "Task failed: Failed to create temporary directory. In some cases, you may have been able to authenticate and did not have permissions on the target directory...

=> Missing home directory for setup user 
=> create home directory
  sudo mkdir /home/k8-wk1
  sudo chown -R k8-wk1:k8-wk1 /home/k8-wk1
  sudo chmod 750 /home/k8-wk1

  # Change k8-wk1 user name to your intended user.
  # Remote SSH into this VM node to run above commands.



PSQL
/etc/postgresql/16/main/postgresql.conf
To find postgres config file path :
locate postgresql.conf
or find / -name postgresql.conf

If not take effect => may be set by `sudo -u postgres psql`
=> Run sudo -u postgres psql then run sql query:
SELECT name, setting, sourcefile, pending_restart 
FROM pg_settings 
WHERE name = 'max_connections';


sudo systemctl stop postgresql
