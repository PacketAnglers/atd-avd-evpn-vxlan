# Deploy L3LS with EVPN VXLAN using AVD and CVP
This PoC will allow you to use Arista's AVD automation framework to deploy a dual datacenter, layer 3 leaf spine fabric with EVPN VXLAN.  Additionally, it incorporates CVP into the CI/CD pipeline for configuration change management and auditing.  The PoC has some devices with static configurations that need to be deployed with the via ansible playbooks utilizing the **eos_config** role, and some that you will be modifying and implementing yourself using AVD.

## Datacenter Fabric Topology
Below is a network diagram of the datacenter topology you will be working with.  In this topology, all `s1` devices correspond with `sites/dc1`, and all `s2` devices correspond with `sites/dc2`.

![Topology](images/atd-l3ls-topo.png)

## Directory Structure and Layout
Since this topology is for two datacenters, the vars and inventory directories and files are broken out per datacenter.  This means there is an inventory file and group_vars directory for each datacenter.  Additionally, since some things are standard across both datacenters, there is a global_vars directory and file.  Finally, the playbooks for building and deploying changes are also split between the datacenters.  The tree structure below outlines all of these items:

### Directory and File Structure
```bash
|---global_vars
    |---global_dc_vars.yml
|---playbooks
    |---build_dc1.yml
    |---build_dc2.yml
    |---cfg_dc1_dci.yml
    |---cfg_dc2_dci.yml
    |---deploy_dc1.yml
    |---deploy_dc2.yml
|---sites
    |---dc1 [Inventory and VARs for DC1 only]
    |   |---dci_configs [Non AVD Configs for Topology]
    |   |   |---s1-core1.cfg
    |   |   |---s1-core2.cfg
    |   |---groups_vars
    |   |   |---dc1_fabric_ports.yml
    |   |   |---dc1_fabric_services.yml
    |   |   |---dc1_fabric.yml
    |   |   |---dc1_hosts.yml
    |   |   |---dc1_leafs.yml
    |   |   |---dc1_spines.yml
    |   |   |---dc1.yml
    |   |---inventory.yml
    |---dc2 [Inventory and VARs for DC2 only]
    |   |---dci_configs [Non AVD Configs for Topology]
    |   |   |---s2-core1.cfg
    |   |   |---s2-core2.cfg
    |   |---groups_vars
    |   |   |---dc2_fabric_ports.yml
    |   |   |---dc2_fabric_services.yml
    |   |   |---dc2_fabric.yml
    |   |   |---dc2_hosts.yml
    |   |   |---dc2_leafs.yml
    |   |   |---dc2_spines.yml
    |   |   |---dc2.yml
    |   |---inventory.yml
|---ansible.cfg
|---Makefile
|---README.md
```

# Getting AVD going in the ATD programmability IDE
From your ATD environment, launch the programmability IDE, enter the password, and launch a new terminal:

![IDE](images/programmability_ide.png)

## STEP #1 - Install deepmerge

- From the terminal session, run the following command.

``` bash
pip install deepmerge
```

## STEP #2 - Clone Necessary Repos

- Change working directory. The following commands will be executed from here.

``` bash
cd labfiles
```

- Install the AVD devel collection

``` bash
ansible-galaxy collection install git+https://github.com/aristanetworks/ansible-avd.git#/ansible_collections/arista/avd/,devel
```

- Clone the POC Repo

``` bash
git clone https://github.com/PacketAnglers/atd-avd-evpn-vxlan.git
```

- At this point you should see the `atd-avd-evpn-vxlan` directory under the labfiles directory.

## STEP #3 - Update Passwords and SSH Keys

The ATD Lab switches are preconfigured with MD5 encrypted passwords.  AVD uses sha512 passwords so we need to convert the current MD5 password to sha512.  **You will need to login to any switch in the topology to complete this step.**  

From the Programmibility IDE Explorer:

- Navigate to the `labfiles/atd-avd-evpn-vxlan/sites/dc1` directory.
- Double click on the **dc1.yml** file to open an editor tab.
- Update line 6.  **Follow** instructions per line below.

### Update Line 6

- Update `ansible_password` key (line 4) with your unique lab password found on the **Usernames and Passwords** section of your lab topology screen.

``` yaml
# sites/dc1/group_vars/dc1.yml
#
# Update password with lab credentials
ansible_password: ######### 
```
- Repeat the above steps for the **dc2.yml** file, in the `sites/dc2` directory.

## Change directory to the actual repo
``` bash
cd atd-avd-evpn-vxlan
```

## Building and Deploying Configurations
