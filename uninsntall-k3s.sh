sudo /usr/local/bin/k3s-killall.sh
[sudo] password for nickfarrow: 
+ [ -s /etc/systemd/system/k3s.service ]
+ basename /etc/systemd/system/k3s.service
+ systemctl stop k3s.service
+ [ -x /etc/init.d/k3s* ]
+ killtree 3162 4462 4589 4625 5072 5181 5221 5228 5247 5249 5260 5261 5486 5523 5560 5565 5572 5611
+ kill -9 3162 4462 4589 4625 5072 5181 5221 5228 5247 5249 5260 5261 5486 5523 5560 5565 5572 5611
+ do_unmount_and_remove /run/k3s
+ set +x
sh -c 'umount -f "$0" && rm -rf "$0"' /run/k3s/containerd/io.containerd.runtime.v2.task/k8s.io/f2f176794cab00f25aca01676b1dc74295f3d04759dd6ce300484a1efdf61d3e/rootfs
sh -c 'umount -f "$0" && rm -rf "$0"' /run/k3s/containerd/io.containerd.runtime.v2.task/k8s.io/f2d578c7925eee3af45c34e57e4272688b070b1ca299757dbf454b6c4ed3b4a7/rootfs
sh -c 'umount -f "$0" && rm -rf "$0"' /run/k3s/containerd/io.containerd.runtime.v2.task/k8s.io/0cf16bbcd996db178e15c752c7e6586f0cb0ebaa460dde99db69f9018b5a603e/rootfs
sh -c 'umount -f "$0" && rm -rf "$0"' /run/k3s/containerd/io.containerd.grpc.v1.cri/sandboxes/f2d578c7925eee3af45c34e57e4272688b070b1ca299757dbf454b6c4ed3b4a7/shm
sh -c 'umount -f "$0" && rm -rf "$0"' /run/k3s/containerd/io.containerd.grpc.v1.cri/sandboxes/e46dda5ac9ee5bbdc939d2c27fa63771fd7c911194971bfc9716889ce919a0da/shm
sh -c 'umount -f "$0" && rm -rf "$0"' /run/k3s/containerd/io.containerd.grpc.v1.cri/sandboxes/e0105aded32ccd31f7305eec74f5d85b35624701ce4c2a549053b537f9ab51c3/shm
+ do_unmount_and_remove /var/lib/kubelet/pods
+ set +x
sh -c 'umount -f "$0" && rm -rf "$0"' /var/lib/kubelet/pods/d3653511-c63b-4fcc-9e7d-287c04426b7e/volumes/kubernetes.io~projected/kube-api-access-vp9vt
sh -c 'umount -f "$0" && rm -rf "$0"' /var/lib/kubelet/pods/b4bd49a9-0ee4-45c5-8e11-605c4826434f/volumes/kubernetes.io~projected/kube-api-access-rm7t7
sh -c 'umount -f "$0" && rm -rf "$0"' /var/lib/kubelet/pods/46bae10a-b84b-40f5-ac72-9c87ac34a6c4/volumes/kubernetes.io~projected/kube-api-access-g7xsv
sh -c 'umount -f "$0" && rm -rf "$0"' /var/lib/kubelet/pods/1fc7ee49-e4b0-47aa-a475-856c1349e63e/volumes/kubernetes.io~projected/kube-api-access-nrxsx
sh -c 'umount -f "$0" && rm -rf "$0"' /var/lib/kubelet/pods/1567584b-1a37-4344-8837-da0db5b1750e/volumes/kubernetes.io~projected/kube-api-access-nv8hg
sh -c 'umount -f "$0" && rm -rf "$0"' /var/lib/kubelet/pods/1567584b-1a37-4344-8837-da0db5b1750e/volumes/kubernetes.io~projected/hubble-tls
sh -c 'umount -f "$0" && rm -rf "$0"' /var/lib/kubelet/pods/1567584b-1a37-4344-8837-da0db5b1750e/volumes/kubernetes.io~projected/clustermesh-secrets
sh -c 'umount -f "$0" && rm -rf "$0"' /var/lib/kubelet/pods/06770c53-02ae-4f1d-bb1f-355082703633/volumes/kubernetes.io~projected/kube-api-access-cjpsm
+ do_unmount_and_remove /var/lib/kubelet/plugins
+ set +x
+ do_unmount_and_remove /run/netns/cni-
+ set +x
sh -c 'umount -f "$0" && rm -rf "$0"' /run/netns/cni-fa98f3e6-712c-d9e8-eb88-148ca38052ee
sh -c 'umount -f "$0" && rm -rf "$0"' /run/netns/cni-f0e54d04-0fe8-5bb9-3626-957c7d270d38
sh -c 'umount -f "$0" && rm -rf "$0"' /run/netns/cni-d9baa9eb-0399-b6fd-854e-156287678708
sh -c 'umount -f "$0" && rm -rf "$0"' /run/netns/cni-cdb40683-9d99-6a98-37dd-31709d98b26e
sh -c 'umount -f "$0" && rm -rf "$0"' /run/netns/cni-cb37677e-89e5-2e2d-8939-42a3edcd4c6e
sh -c 'umount -f "$0" && rm -rf "$0"' /run/netns/cni-b7fde884-73e8-e772-931d-dcabd439d329
sh -c 'umount -f "$0" && rm -rf "$0"' /run/netns/cni-01db8251-c63f-07b6-5b26-e39d01064168
+ ip netns show
+ grep cni-
+ xargs -r -t -n 1 ip netns delete
+ remove_interfaces
+ ip link show
+ grep master cni0
+ read ignore iface ignore
+ ip link delete cni0
Cannot find device "cni0"
+ ip link delete flannel.1
Cannot find device "flannel.1"
+ ip link delete flannel-v6.1
Cannot find device "flannel-v6.1"
+ ip link delete kube-ipvs0
Cannot find device "kube-ipvs0"
+ ip link delete flannel-wg
Cannot find device "flannel-wg"
+ ip link delete flannel-wg-v6
Cannot find device "flannel-wg-v6"
+ command -v tailscale
+ [ -n  ]
+ rm -rf /var/lib/cni/
+ grep -v CNI-
+ iptables-save
+ grep -v KUBE-
+ grep -iv flannel
+ iptables-restore
# Warning: iptables-legacy tables present, use iptables-legacy-save to see them
+ ip6tables-save
+ grep -v KUBE-
+ grep -iv flannel
+ grep -v CNI-
+ ip6tables-restore
# Warning: ip6tables-legacy tables present, use ip6tables-legacy-save to see them


sudo /usr/local/bin/k3s-uninstall.sh

sudo /usr/local/bin/k3s-uninstall.sh
+ id -u
+ [ 0 -eq 0 ]
+ K3S_DATA_DIR=/var/lib/rancher/k3s
+ /usr/local/bin/k3s-killall.sh
+ [ -s /etc/systemd/system/k3s.service ]
+ basename /etc/systemd/system/k3s.service
+ systemctl stop k3s.service
+ [ -x /etc/init.d/k3s* ]
+ killtree
+ kill -9
+ do_unmount_and_remove /run/k3s
+ set +x
+ do_unmount_and_remove /var/lib/kubelet/pods
+ set +x
sh -c 'umount -f "$0" && rm -rf "$0"' /var/lib/kubelet/pods/d3653511-c63b-4fcc-9e7d-287c04426b7e/volumes/kubernetes.io~projected/kube-api-access-vp9vt
sh -c 'umount -f "$0" && rm -rf "$0"' /var/lib/kubelet/pods/b4bd49a9-0ee4-45c5-8e11-605c4826434f/volumes/kubernetes.io~projected/kube-api-access-rm7t7
sh -c 'umount -f "$0" && rm -rf "$0"' /var/lib/kubelet/pods/46bae10a-b84b-40f5-ac72-9c87ac34a6c4/volumes/kubernetes.io~projected/kube-api-access-g7xsv
sh -c 'umount -f "$0" && rm -rf "$0"' /var/lib/kubelet/pods/1fc7ee49-e4b0-47aa-a475-856c1349e63e/volumes/kubernetes.io~projected/kube-api-access-nrxsx
sh -c 'umount -f "$0" && rm -rf "$0"' /var/lib/kubelet/pods/1567584b-1a37-4344-8837-da0db5b1750e/volumes/kubernetes.io~projected/kube-api-access-nv8hg
sh -c 'umount -f "$0" && rm -rf "$0"' /var/lib/kubelet/pods/1567584b-1a37-4344-8837-da0db5b1750e/volumes/kubernetes.io~projected/hubble-tls
sh -c 'umount -f "$0" && rm -rf "$0"' /var/lib/kubelet/pods/1567584b-1a37-4344-8837-da0db5b1750e/volumes/kubernetes.io~projected/clustermesh-secrets
sh -c 'umount -f "$0" && rm -rf "$0"' /var/lib/kubelet/pods/06770c53-02ae-4f1d-bb1f-355082703633/volumes/kubernetes.io~projected/kube-api-access-cjpsm
+ do_unmount_and_remove /var/lib/kubelet/plugins
+ set +x
+ do_unmount_and_remove /run/netns/cni-
+ set +x
+ ip netns show
+ + grep cni-
xargs -r -t -n 1 ip netns delete
+ remove_interfaces
+ + grep master cni0
ip link show
+ read ignore iface ignore
+ ip link delete cni0
Cannot find device "cni0"
+ ip link delete flannel.1
Cannot find device "flannel.1"
+ ip link delete flannel-v6.1
Cannot find device "flannel-v6.1"
+ ip link delete kube-ipvs0
Cannot find device "kube-ipvs0"
+ ip link delete flannel-wg
Cannot find device "flannel-wg"
+ ip link delete flannel-wg-v6
Cannot find device "flannel-wg-v6"
+ command -v tailscale
+ [ -n  ]
+ rm -rf /var/lib/cni/
+ iptables-save
+ + grep+ grep -iv flannel
 -v KUBE-
+ iptables-restore
grep -v CNI-
# Warning: iptables-legacy tables present, use iptables-legacy-save to see them
+ ip6tables-save
+ grep -v KUBE-
+ grep -v CNI-
+ grep -iv flannel
+ ip6tables-restore
# Warning: ip6tables-legacy tables present, use ip6tables-legacy-save to see them
+ command -v systemctl
/usr/bin/systemctl
+ systemctl disable k3s
Removed "/etc/systemd/system/multi-user.target.wants/k3s.service".
+ systemctl reset-failed k3s
Failed to reset failed state of unit k3s.service: Unit k3s.service not loaded.
+ systemctl daemon-reload
+ command -v rc-update
+ rm -f /etc/systemd/system/k3s.service
+ rm -f /etc/systemd/system/k3s.service.env
+ trap remove_uninstall EXIT
+ [ -L /usr/local/bin/kubectl ]
+ rm -f /usr/local/bin/kubectl
+ [ -L /usr/local/bin/crictl ]
+ rm -f /usr/local/bin/crictl
+ [ -L /usr/local/bin/ctr ]
+ rm -f /usr/local/bin/ctr
+ rm -rf /etc/rancher/k3s
+ rm -rf /run/k3s
+ rm -rf /run/flannel
+ clean_mounted_directory /var/lib/rancher/k3s
+ grep -q  /var/lib/rancher/k3s /proc/mounts
+ rm -rf /var/lib/rancher/k3s
+ return 0
+ rm -rf /var/lib/kubelet
rm: cannot remove '/var/lib/kubelet/pods/1567584b-1a37-4344-8837-da0db5b1750e/volumes/kubernetes.io~projected/clustermesh-secrets': Device or resource busy
rm: cannot remove '/var/lib/kubelet/pods/1567584b-1a37-4344-8837-da0db5b1750e/volumes/kubernetes.io~projected/hubble-tls': Device or resource busy
rm: cannot remove '/var/lib/kubelet/pods/1567584b-1a37-4344-8837-da0db5b1750e/volumes/kubernetes.io~projected/kube-api-access-nv8hg': Device or resource busy
+ rm -f /usr/local/bin/k3s
+ rm -f /usr/local/bin/k3s-killall.sh
+ type yum
+ type rpm-ostree
+ type zypper
+ remove_uninstall
+ rm -f /usr/local/bin/k3s-uninstall.sh

sudo /usr/local/bin/k3s-agent-uninstall.sh

not found