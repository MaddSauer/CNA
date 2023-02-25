# CNA

path of discovery

swfs:
- VM
  * master & volume : install swfs master and volume
  * volume : up and download files via curl
- OCP
  * deploy helm chart (disable mysql, change node-selectors, customize storage-class iscsi-ext4)
- VM
  * setup systemd services (master, volume, filer)
  * multi-master, multi-volume
  
Todo:
  * configure services for filer
    * S3
    * cockroachdb
    * restic
  * add VM as swfs client
    * deploy k3s as a kubernetes 
    * deploy cockroachdb on this k3s
    * configure cockroachdb to use swfs as storage
  * configure swfs to use s3 in the backend
  * backup filecontent of volumes with restic
  * 
    
