sudo snap install k8s --classic
sudo k8s bootstrap

sudo k8s status

cluster status:           not ready
control plane nodes:      192.168.237.128:6400 (voter)
high availability:        no
datastore:                etcd
network:                  Failed to deploy Cilium Network, the error was: interface flannel.1 uses the same destination port as cilium. Please consider changing the Cilium tunnel port
dns:                      enabled at 10.152.183.187
ingress:                  Failed to deploy Cilium Ingress, the error was: failed to enable ingress: cannot upgrade ck-network as it is not installed
load-balancer:            disabled
local-storage:            enabled at /var/snap/k8s/common/rawfile-storage
gateway                   Failed to deploy Cilium Gateway, the error was failed to upgrade Gateway API cilium configuration: cannot upgrade ck-network as it is not installed


Remove flannel
(No idea when installed it, may be kc apply smth)

sudo rm -rf /var/lib/cni/flannel/
sudo rm -rf /run/flannel/

sudo ip link delete flannel.1
sudo ip link delete cni0


cluster status:           not ready
control plane nodes:      192.168.237.128:6400 (voter)
high availability:        no
datastore:                etcd
network:                  enabled <--
dns:                      enabled at 10.152.183.187
ingress:                  Failed to deploy Cilium Ingress, the error was: failed to enable ingress: cannot upgrade ck-network as it is not installed
load-balancer:            disabled
local-storage:            enabled at /var/snap/k8s/common/rawfile-storage
gateway                   Failed to deploy Cilium Gateway, the error was failed to upgrade Gateway API cilium configuration: cannot upgrade ck-network as it is not installed


cluster status:           ready
control plane nodes:      192.168.237.128:6400 (voter)
high availability:        no
datastore:                etcd
network:                  enabled
dns:                      enabled at 10.152.183.187
ingress:                  disabled --> ? 
load-balancer:            disabled
local-storage:            enabled at /var/snap/k8s/common/rawfile-storage
gateway                   enabled


ingress
=> helm list -n kube-system   # Verify existing installations
Error: kubernetes cluster unreachable: Get "https://127.0.0.1:6443/version": tls: failed to verify certificate: x509: certificate signed by unknown authority

Install
helm install cilium cilium/cilium \
  --namespace kube-system \
  --set ingressController.enabled=true \
  --set ingressController.default=true

  => Error: INSTALLATION FAILED: repo cilium not found

helm repo add cilium https://helm.cilium.io/
helm repo update

helm search repo cilium/cilium

helm install cilium cilium/cilium --namespace=kube-system
# or above helm install

level=ERROR msg="cluster reachability check failed: kubernetes cluster unreachable: Get \"https://127.0.0.1:6443/version\": tls:
 failed to verify certificate: x509: certificate signed by unknown authority"
Error: INSTALLATION FAILED: cluster reachability check failed: kubernetes cluster unreachable: 
Get "https://127.0.0.1:6443/version": tls: failed to verify certificate: x509: certificate signed by unknown authority

=> SSL issue. Self certificate have to reinstall. (previous is for k3s)

List process with kube-apiserver:

/snap/k8s/5092/bin/kube-apiserver --advertise-address=192.168.237.128 --allow-privileged=true 
--anonymous-auth=false --authentication-token-webhook-config-file=/var/snap/k8s/common/args/conf.d/auth-token-webhook.conf 
--authorization-mode=Node,RBAC --client-ca-file=/etc/kubernetes/pki/client-ca.crt --enable-admission-plugins=NodeRestriction 
--etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt 
--etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key --etcd-servers=https://127.0.0.1:2379 
--kubelet-certificate-authority=/etc/kubernetes/pki/ca.crt 
--kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt 
--kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key 
--kubelet-preferred-address-types=InternalIP,Hostname,InternalDNS,ExternalDNS,ExternalIP 
--profiling=false --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt 
--proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key --request-timeout=300s 
--requestheader-allowed-names=front-proxy-client --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt 
--requestheader-extra-headers-prefix=X-Remote-Extra- --requestheader-group-headers=X-Remote-Group 
--requestheader-username-headers=X-Remote-User --secure-port=6443 
--service-account-issuer=https://kubernetes.default.svc 
--service-account-key-file=/etc/kubernetes/pki/serviceaccount.key 
--service-account-signing-key-file=/etc/kubernetes/pki/serviceaccount.key --service-cluster-ip-range=10.152.183.0/24 
--tls-cert-file=/etc/kubernetes/pki/apiserver.crt 
--tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305 
--tls-min-version=VersionTLS12 --tls-private-key-file=/etc/kubernetes/pki/apiserver.key


These key bellow seem default => Self signed would not work ?
--kubelet-certificate-authority=/etc/kubernetes/pki/ca.crt 
--kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt 
--kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key 

This error is a classic "Conflict of Authority." Your Terraform/Kubectl is trying to talk to the new K3s API using the certificate credentials from your old installation.

Since K3s generates a unique Root CA for every fresh install, your ~/.kube/config is pointing to a "Ghost" cluster that no longer exists.

Step 1: Nuclear Reset (Old Config & Certs)
Before we fix the new one, we must clear the local cache to prevent Terraform from getting confused.

# 1. Back up and remove the old local config
mv ~/.kube/config ~/.kube/config.bak

# 2. Clear any cached discovery information
rm -rf ~/.kube/cache

Step 2: Extract the "New" Authority
# Ensure the file is readable by your user
sudo chmod 644 /etc/rancher/k3s/k3s.yaml

# Copy it to your home directory (or use SCP/Ansible to pull it to your dev machine)
mkdir -p ~/.kube
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config

nickfarrow@nickfarrow-VMware:~$ netpentl
[sudo] password for nickfarrow: 
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode      PID/Program name    
tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN      0          9903595    250647/cupsd        
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      0          25326      1/init              
tcp        0      0 127.0.0.1:45169         0.0.0.0:*               LISTEN      0          12347050   299956/cilium-agent 
tcp        0      0 192.168.237.128:6400    0.0.0.0:*               LISTEN      0          12289818   292081/k8sd         
tcp        0      0 0.0.0.0:53              0.0.0.0:*               LISTEN      0          27153      1603/dnsmasq        
tcp        0      0 127.0.0.1:10256         0.0.0.0:*               LISTEN      0          12303407   294210/kube-proxy   
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      0          28192      1640/nginx: master  
tcp        0      0 127.0.0.1:10249         0.0.0.0:*               LISTEN      0          12295104   294210/kube-proxy   
tcp        0      0 127.0.0.1:10248         0.0.0.0:*               LISTEN      0          12305044   294712/kubelet      
tcp        0      0 192.168.237.128:2380    0.0.0.0:*               LISTEN      0          12291720   293902/etcd         
tcp        0      0 192.168.237.128:2379    0.0.0.0:*               LISTEN      0          12291722   293902/etcd         
tcp        0      0 127.0.0.1:2379          0.0.0.0:*               LISTEN      0          12291721   293902/etcd         
tcp        0      0 192.168.237.128:4240    0.0.0.0:*               LISTEN      0          12354885   299956/cilium-agent 
tcp        0      0 127.0.0.1:9879          0.0.0.0:*               LISTEN      0          12349169   299956/cilium-agent 
tcp        0      0 127.0.0.1:9891          0.0.0.0:*               LISTEN      0          12343753   299167/cilium-opera 
tcp        0      0 127.0.0.1:9890          0.0.0.0:*               LISTEN      0          12346888   299956/cilium-agent 
tcp        0      0 127.0.0.1:9234          0.0.0.0:*               LISTEN      0          12342000   299167/cilium-opera 
tcp        0      0 127.0.0.1:42443         0.0.0.0:*               LISTEN      0          12292956   294112/containerd   
tcp6       0      0 :::10250                :::*                    LISTEN      0          12305039   294712/kubelet      
tcp6       0      0 :::10257                :::*                    LISTEN      0          12304130   294208/kube-control 
tcp6       0      0 :::10259                :::*                    LISTEN      0          12303571   294228/kube-schedul 
tcp6       0      0 :::22                   :::*                    LISTEN      0          24361      1/init              
tcp6       0      0 :::53                   :::*                    LISTEN      0          27155      1603/dnsmasq        
tcp6       0      0 :::80                   :::*                    LISTEN      0          28193      1640/nginx: master  
tcp6       0      0 :::4244                 :::*                    LISTEN      0          12348892   299956/cilium-agent 
tcp6       0      0 :::6443                 :::*                    LISTEN      0          12293107   294194/kube-apiserv 
tcp6       0      0 :::9963                 :::*                    LISTEN      0          12343758   299167/cilium-opera 
tcp6       0      0 ::1:631                 :::*                    LISTEN      0          9903594    250647/cupsd   

6443 => kube-apiserv (k3 default)
6400 k8sd


sudo k8s kubeconfig > ~/.kube/config

Error: unknown command "kubeconfig" for "k8s"

Canonical k3s
nickfarrow@nickfarrow-VMware:~$ sudo k8s config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: xxx=
    server: https://192.168.237.128:6443
  name: k8s
contexts:
- context:
    cluster: k8s
    user: k8s-user
  name: k8s
current-context: k8s
kind: Config
preferences: {}
users:
- name: k8s-user
  user:
    client-certificate-data: xxx=
    client-key-data: xxx=

Wow Cilium is not necessary (overkill for single node)

=> use default ingress

1. Is Ingress (Cilium) necessary?
Short answer: No, it is not strictly necessary for the cluster to function, but it is necessary for your AI Dev Team to access the apps.

Kube-proxy: This always works by default. It handles internal communication (Pod A talking to Pod B).

--> The Problem: Without an Ingress or Load Balancer, you can only access your AI dashboards 
  (like Jupyter or Gradio) using kubectl port-forward or complex NodePort addresses (e.g., 192.168.237.128:32045).

The Goal: You want ai-dev.local to just work. For that, you need an Ingress controller (like Nginx or Cilium).

2. Should you use Cilium?
Cilium is excellent, but for a single-node bare metal AI setup, it might be overkill and adds complexity (especially with eBPF requirements).

My Recommendation: If you are struggling with the installation, don't start with Cilium. Use the built-in ingress to get your team running first:

sudo k8s enable ingress

This will install a standard Nginx Ingress controller which is much easier to manage with Terraform/ArgoCD.

OK
[sudo] password for nickfarrow: 
cluster status:           ready
control plane nodes:      192.168.237.128:6400 (voter)
high availability:        no
datastore:                etcd
network:                  enabled
dns:                      enabled at 10.152.183.187
ingress:                  enabled  <--
load-balancer:            disabled
local-storage:            enabled at /var/snap/k8s/common/rawfile-storage
gateway                   enabled


Uninstall k3s



Rancher
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Start and enable Docker
sudo systemctl enable docker
sudo systemctl start docker


sudo docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  --privileged \
  rancher/rancher:latest

  --privileged: Required for Rancher to manage nodes.

Step 3: Access the Rancher UI 
Open your browser and navigate to https://<YOUR_UBUNTU_IP>.
Set Password: On the first login, you will be prompted to set a bootstrap password, or you can retrieve the auto-generated one using:

  sudo docker logs <RANCHER_CONTAINER_ID> 2>&1 | grep "Bootstrap Password:"

sudo swapoff -a

sudo vim /etc/fstab => comment #

free -h
# Look for "Swap: 0B 0B 0B" in the output
swapon --show
# If this returns no output, swap is off.

4. (Optional) Mask Swap with Systemd
Sometimes, systemd may try to re-enable swap automatically. To prevent this, you can mask the swap target: 

sudo systemctl mask swap.target


Uninstall k8s
sudo k8s reset

sudo snap remove --purge k8s

sudo snap install k8s --channel=latest/stable
or --classic

sudo systemctl stop snap.k8s.kube-apiserver.service
sudo systemctl restart snap.k8s.kube-apiserver.service
rm -rf ~/.kube

sudo systemctl status snap.k8s.kube-apiserver.service

journalctl -u kubelet

=> kubelet.service: Referenced but unset environment variable evaluates to an empty string: KUBELET_KUBEADM_ARGS

sudo kubeadm join phase kubelet-start

kk
