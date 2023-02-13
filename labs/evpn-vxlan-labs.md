# EVPN VXLAN Labs

The goal of these labs are to show how AVD eases Day 2 and beyond network operations.  You will complete two 

<br>
<br>

## Lab 1 - Add VLANs to EVPN VXLAN Topology

This lab will show you how simple it is to automate the configuration changes associated with adding additional VLANs to your EVPN VXLAN topology.  In a non-automated EVPN VXLAN topology, anytime a new VLAN needs to be added and extended, it has to be created on every switch, added to VXLAN, and added to the BGP configuration on the relevant devices.  During this lab, you will modify the `dc1_fabric_services.yml` and `dc2_fabric_services.yml` vars files to add the new VLANs listed below.  



Modify the ***fabric_services*** vars files to add the following VLANs:

```yaml

VLAN ID: 30
Name: thirty
Description: thirty
Tags: ATD
MTU: 9014
vIP: 10.30.30.1/24
EVPN:  True

VLAN ID: 40
Name: forty
Description: forty
Tags: ATD
MTU: 9014
vIP: 10.40.40.1/24
EVPN:  True

VLAN ID: 50
Name: fifty
Description: fifty
Tags: ATD
MTU: 9014
vIP: 10.50.50.1/24
EVPN:  True

```

After modifying and saving the vars files, complete the following steps:

1) Issue the `make build-dc1` and `make build-dc2` to generate the new structured and device configurations.

2) Review the configurations in their respective directories and verify the changes are correct.

3) Review the changes to the documentation that is auto-created.

4) Issue the `make deploy-dc1` and `make deploy-dc2`, review the created change controls in CVP, and approve.

5) Login to leaf switches 1 and 2 and verify the new configurations are present.

<br>
<br>


## Lab 2 - Add Leaf Pairs 3 and 4

This lab 