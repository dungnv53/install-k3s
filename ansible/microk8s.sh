K8s = Kubernetes

# Remove microk8s 
  (in case installation got Error)

# 1. Stop the snap service if it's running
sudo snap stop microk8s

# 2. Unmount all microk8s specific mounts
# This is the most important step to fix the "directory not empty" error
mount | grep 'snap/microk8s' | awk '{print $3}' | xargs -r sudo umount -l

# 3. Now remove the snap via purge
sudo snap remove microk8s --purge

# 4. Clean up any leftover directories
sudo rm -rf /var/snap/microk8s
sudo rm -rf /var/lib/kubelet

# Get list all nodes
microk8s kubectl  get nodes


# Join node into a cluster
# Step 1. Generate the Join Command
# gen token (run from a active node or master node)
microk8s add-node
# Step 2: Join the Node
microk8s join <MASTER_IP>:<PORT>/<TOKEN>


# helm and helmfile manage state of Kubernetes cluster
# helm - Kubernetes package manager

mkdir -p ~/.kube
sudo microk8s config > ~/.kube/config


helmfile -f infrastructure/helmfile.yaml -l name=strimzi-operator sync
helmfile -f infrastructure/helmfile.yaml -l name=kafka-ui sync

Error:
panic: unexpected error: exec: "helm": executable file not found in $PATH

goroutine 10 [running]:
...

=> helm and helmfile command net recognized (alias issue)

Ah, that explains it! MicroK8s encapsulates everything inside its own environment, including Helm (if you enabled it via microk8s enable helm).

When you type microk8s helm, it works, but helmfile has no idea what MicroK8s is—it is looking explicitly for a binary named exactly helm inside your system $PATH.

Standard shell aliases (like alias helm='microk8s helm') only work inside your interactive terminal; external Go binaries like helmfile cannot read them.

Fix
Option 1: Expose MicroK8s Helm to your system PATH (Recommended)

sudo snap alias microk8s.helm helm

Option 2: Install a standalone Helm binary

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
sudo ./get_helm.sh

One Last Check (Kubeconfig)
Because you are using MicroK8s, helmfile might also complain that it can't find your Kubernetes cluster configurations. If it fails on the next step, make sure your shell knows where the MicroK8s config is by running:
