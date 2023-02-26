# CNA

## learning path to walk through
- k3s : install as a simpl kubernetes
  - one node in every AZ
  - master on all nodes
- swfs : install as k8s deployment first simple setup
  - 3 master
  - 3 volume
  - 1 filer
  - add swfs-storage class
- prometheus operator : install
- prometheus : install
- grafana : 
  - install grafana itself
  - swfs : extend deployment with enabled metrics
  - swfs : deploy swfs grafana template
- CockroachDB
  - swfs : extend deploymant for CRDB
  - CRDB : deploy
  



---
Old path - obsolete

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
    
