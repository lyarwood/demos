#!/bin/bash
#
# This demo was written against a development env of KubeVirt:
# $ git rev-parse HEAD
# 140b5805dd0054b2385bd4094046794e401f4455
# $ git describe --tags --abbrev=0
# v0.58.0
# $ env | grep KUBEVIRT
# KUBEVIRT_PROVIDER=k8s-1.24
# KUBEVIRT_MEMORY=16384
# KUBEVIRT_STORAGE=rook-ceph-default

. ../../../demo-magic/demo-magic.sh

clear

cleanup(){
    ./cluster-up/kubectl.sh delete vm/vm-cirros-csmall 
    ./cluster-up/kubectl.sh delete vm/demo-autoattachinputdevice
    ./cluster-up/kubectl.sh delete vm/demo-preferredinputdevice 
    ./cluster-up/kubectl.sh delete vm/demo-preferredmachinetype 
    ./cluster-up/kubectl.sh delete virtualmachineinstancetype/csmall
    ./cluster-up/kubectl.sh delete virtualmachinepreference/preferredinputdevice
    ./cluster-up/kubectl.sh delete virtualmachinepreference/preferredmachinetype
}

demoDir=$(pwd)
cd /home/lyarwood/redhat/devel/src/k8s/kubevirt/kubevirt

cleanup &>/dev/null

pei "# Agenda"
pei "# 1. Instance type primer"
pei "# 2. New API version v1alpha2"
pei "# 3. AutoAttachInputDevice & PreferredAutoAttachInputDevice"
pei "# 4. PreferredMachineType bugfix"

sleep 5
clear
export TYPE_SPEED=60

pei "# Instance type primer"
pei "#"
pei "# Another quick reminder of the basics of the Instance types API"
pei "#"
pei "# Instance types encapsulate resource and performance characteristics of a VirtualMachine"
pei "# * An amount of guest visible CPU and memory resources must be defined for each Instance type"
pei "# * Instance types can conflict with values provided within the VirtualMachine, for example if both define CPU resources"
pei "#"
pei "# Preferences encapsulate the remaining runtime characteristics of a VirtualMachine"
pei "# * These are preferred values and can be overridden by user defined choices within the VirtualMachine"
pei "#" 
pei "# See the userguide for more context - https://kubevirt.io/user-guide/virtual_machines/instancetypes/"

sleep 5
clear 
export TYPE_SPEED=20

# v1alpha2
. ${demoDir}/demo1.sh

# preferredinputdevice
. ${demoDir}/demo2.sh

# machinetype
. ${demoDir}/demo3.sh
