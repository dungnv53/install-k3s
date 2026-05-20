Errors

When run apt install eg. prometheus got error look like:
[ERROR]: Task failed: Module failed: Failed to update apt cache after 5 retries: W:Updating from such a repository can't be done securely, and is therefore disabled by default., W:See apt-secure(8) manpage for repository creation and user configuration details., E:The repository 'https://ppa.launchpadcontent.net...

=> APT 
Your Ansible playbook is OK. The problem is your Ubuntu APT repositories are broken.

These PPAs do not support Ubuntu Noble (24.04):
eg.
ppa:cartes/drawing

So apt update fails before Ansible can install anything.

sudo add-apt-repository --remove ppa:cartes/drawing
sudo add-apt-repository --remove ppa:ubuntu-vn/ppa

Driver for nvidia ? 
Node Exporter prometheus for GPU...