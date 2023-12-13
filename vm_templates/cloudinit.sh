export URL="https://cloud.debian.org/images/cloud/bookworm/20230711-1438/debian-12-generic-amd64-20230711-1438.qcow2"
export NAME="Debian12.qcow2"
export VM="Debian12-Template"
export VMID="99999"
export LOCATION="cache-domains"

echo Downloading Image
wget $URL -O $NAME

echo adding qemu agent
virt-customize -a $NAME --install qemu-guest-agent,docker,ansible

echo setting up VM
qm create $VMID --name $VM --memory 1024 --cores 1 -cpu host --net0 virtio,bridge=vmbr0
qm importdisk $VMID $NAME $LOCATION
qm set $VMID --scsihw virtio-scsi-pci --scsi0 $LOCATION:$VMID/vm-$VMID-disk-0.raw,size=10G
qm set $VMID --boot c --bootdisk scsi0 
qm set $VMID --ide2 $LOCATION:cloudinit 
qm set $VMID --serial0 socket --vga serial0
qm set $VMID --agent enabled=1
qm set $VMID --ipconfig0 ip=dhcp

echo Converting to Template
qm template $VMID

echo Deleting image
rm $NAME
