1. Verify Virtualization Support
egrep -c '(vmx|svm)' /proc/cpuinfo

Output 1 or higher => OK

2. Install KVM
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager

3. Start and Verify the Service

sudo systemctl enable --now libvirtd
sudo systemctl status libvirtd

4. Add User to Groups
To manage virtual machines without using sudo every time, add your user to the libvirt and kvm groups

sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER

5. Auto start vm on startup
sudo virsh autostart vm_name

#List all vm
sudo virsh list --all

# Verify
virsh dominfo vm_name