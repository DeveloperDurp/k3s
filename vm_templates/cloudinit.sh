export URL="https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-20220425.0.x86_64.qcow2"
export NAME="centos9.qcow2"
export VM="CentOS9-Template"
export VMID="99999"
export LOCATION="domains"

echo Downloading Image
wget $URL -O $NAME

echo adding qemu agent
virt-customize -a $NAME --install qemu-guest-agent

echo setting up VM
qm create $VMID --name $VM --memory 1024 --cores 1 -cpu host --net0 virtio,bridge=vmbr1
qm importdisk $VMID $NAME $LOCATION
qm set $VMID --scsihw virtio-scsi-pci --scsi0 $LOCATION:vm-$VMID-disk-0
qm set $VMID --boot c --bootdisk scsi0 
qm set $VMID --ide2 $LOCATION:cloudinit 
qm set $VMID --serial0 socket --vga serial0
qm set $VMID --agent enabled=1
qm set $VMID --nameserver 192.168.20.1
qm set $VMID --searchdomain durp.loc
qm set $VMID --ciuser administrator

echo Converting to Template
qm template $ID

echo Deleting image
rm $NAME




