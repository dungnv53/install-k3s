Extend storage / memory (vm restart required ?)

k8s => require k8s stop ? No
Drain & Cordon


# Set maximum memory (requires VM restart)
sudo virsh setmaxmem <vm_name> 8G --config

# Set current memory
sudo virsh setmem <vm_name> 8G --config
