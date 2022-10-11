Thanks to
https://github.com/techno-tim/k3s-ansible



When restoring data
kubectl patch pv pvc-08d158a8-2450-4f8c-b8a9-89cada22106a -p '{"spec":{"storageClassName":"longhorn"}}'
