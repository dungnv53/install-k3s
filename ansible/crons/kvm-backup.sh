Key KVM Backup Methods
Virsh Snapshot & Dump (Live Backup): Allows backing up running VMs by creating a snapshot, 
copying the disk image, and merging the snapshot back.
Command: virsh snapshot-create-as --domain <vm_name> <snapshot_name> --disk-only

Offline/Cold Backup: Shuts down the VM to copy the disk file (.qcow2 or .raw) and XML configuration, 
  ensuring 100% data consistency.

LVM Snapshots: Ideal for VMs using Logical Volume Manager (LVM) storage, 
   providing fast, point-in-time snapshots that can be backed up while the VM runs.

XML Configuration Backup: Always back up the VM XML definition file (/etc/libvirt/qemu/) to preserve hardware settings, 
network interfaces, and disk paths.

virsh snapshot-create-as --domain [VM_NAME] --disk-only --atomic

virsh snapshot-create-as --domain ub24-k8s-worker-1 --disk-only --atomic
Domain snapshot 1777016589 created

Default image qcow2 + snapshot 
/var/lib/libvirt/images/

virsh snapshot-create-as myvm snap1 \
  --disk-only \
  --atomic \
  --diskspec vda,file=/data/vm-snaps/snap1.qcow2

Remove snapshot
1. Find disk name
virsh domblklist ub24-k8s-worker-1
vda   /var/lib/libvirt/images/ubuntu24.04-2.1777016589

2. Commit snapshot back
virsh blockcommit <vm-name> vda --active --pivot

3. Delete file

rm /var/lib/libvirt/images/ubuntu24.04-2.1777016589


# Real cli
r1vn@r1vn-MS-7E70:/mnt/vm-storage/backups/kvm$ virsh blockcommit  ub24-k8s-worker-1 vda --active --pivot

Successfully pivoted
r1vn@r1vn-MS-7E70:/mnt/vm-storage/backups/kvm$ virsh domblklist ub24-k8s-worker-1
 Target   Source
-------------------------------------------------------
 vda      /var/lib/libvirt/images/ubuntu24.04-2.qcow2
 sda      -


r1vn@r1vn-MS-7E70:/mnt/vm-storage/backups/kvm$ rm /var/lib/libvirt/images/ubuntu24.04-2.1777016589
rm: remove write-protected regular file '/var/lib/libvirt/images/ubuntu24.04-2.1777016589'? y
rm: cannot remove '/var/lib/libvirt/images/ubuntu24.04-2.1777016589': Permission denied

sudo du -sh /var/lib/libvirt/images/ubuntu24.04-2.1777016589
333M    /var/lib/libvirt/images/ubuntu24.04-2.1777016589

It seem start with 94M => increased quite fast.

Apr 24 14:53 => track it modified 
sudo mv /var/lib/libvirt/images/ubuntu24.04-2.1777016589 /var/lib/libvirt/images/ubuntu24.04-2.1777016589.bak 
=> try move first, if vm ok then rm
Restart vm seem not clean. k8s may broke ? worker / master


Try kvm on local Dev PC first => then try on Dev server.

