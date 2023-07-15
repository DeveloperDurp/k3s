export URL="https://cloud.debian.org/images/cloud/bookworm/20230711-1438/debian-12-generic-amd64-20230711-1438.qcow2"
export NAME="Debian12.qcow2"
export VM="Debian12-Template"
export VMID="99999"
export LOCATION="NVMeSSD"

echo Downloading Image
wget $URL -O $NAME

echo adding qemu agent
virt-customize -a $NAME --install qemu-guest-agent,epel-release
virt-customize -a $NAME --install ansible

echo setting up VM
qm create $VMID --name $VM --memory 1024 --cores 1 -cpu host --net0 virtio,bridge=vmbr1
qm importdisk $VMID $NAME $LOCATION
qm set $VMID --scsihw virtio-scsi-pci --scsi0 $LOCATION:vm-$VMID-disk-0,size=10G
qm set $VMID --boot c --bootdisk scsi0 
qm set $VMID --ide2 $LOCATION:cloudinit 
qm set $VMID --serial0 socket --vga serial0
qm set $VMID --agent enabled=1
qm set $VMID --nameserver 192.168.20.1
qm set $VMID --searchdomain durp.loc
qm set $VMID --ciuser administrator

echo Converting to Template
qm template $VMID

echo Deleting image
rm $NAME
