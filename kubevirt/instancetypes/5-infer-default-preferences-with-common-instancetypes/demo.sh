#!/bin/bash

. ../../../demo-magic/demo-magic.sh

clear

cleanup(){
    ./_kubevirt/cluster-up/kubectl.sh delete vms/vm-cirros-ds
}

demoDir=$(pwd)

cd /home/lyarwood/redhat/devel/src/k8s/kubevirt/ssp-operator

cleanup &>/dev/null

unset TYPE_SPEED

pei "# -----------------------------------------------------------------------"
pei "# Demo - KubeVirt - Instance Type inference from Golden Image DataSources"
pei "# -----------------------------------------------------------------------"
pei "#"
pei "# This Demo uses the SSP operator to deploy kubevirt/common-instancetypes and a decorated golden image via CDI before using the InferFromVolume KubeVirt feature to discover and use the appropriate instance type and preference when creating a VirtualMachine."
pei "#"
pei "# https://github.com/lyarwood/demos/tree/main/kubevirt/instancetypes/5-infer-default-preferences-with-common-instancetypes"
pei "# "

sleep 5

export TYPE_SPEED=60

clear

pei "# "
pei "env | grep KUBEVIRT"
pei "# "
pei "# The following command was used to deploy this upstream SSP operator development environment:"
pei "# "
pei "# $ make kubevirt-down && make kubevirt-up && SSP_BUILD_RUNTIME=docker make kubevirt-sync"
pei "# "
pei "# Note however that this requires the following unmerged (approval welcome!) kubevirtci change to install the latest version of CDI:"
pei "# "
pei "# cluster-up: Introduce and support KUBEVIRT_DEPLOY_CDI_LATEST"
pei "# https://github.com/kubevirt/kubevirtci/pull/948"
pei "# "
pei "# The following CirrOS based DataImportCronTemplate has been added to the SSP CR for this demo:"
pei "# "
pei "yq .spec.commonTemplates.dataImportCronTemplates ${demoDir}/ssp.yaml"

sleep 5

pei "# "
pei "# This in turn leaves the following resources present in the environment with the instancetype.kubevirt.io/default-{instancetype,preference} labels:"
pei "# "
pei "./_kubevirt/cluster-up/kubectl.sh get all,pvc -A -l 'instancetype.kubevirt.io/default-preference,instancetype.kubevirt.io/default-instancetype'"

sleep 5

pei "# "
pei "# For this demo we only really care about the DataSource but the inferFromVolume feature will work with any volume backed by a decorated DataVolume, DataSource or PVC:"
pei "# "
pei "./_kubevirt/cluster-up/kubectl.sh get -n kubevirt-os-images datasource/cirros -o json | jq .metadata.labels"

sleep 5

pei "# "
pei "# Thanks to the SSP operator common_instancetypes operand we also have VirtualMachineCluster{Instancetypes,Preferences} from the kubevirt/common-instancetypes project deployed in the environment:"
pei "# "
pei "./_kubevirt/cluster-up/kubectl.sh get all -A -l app.kubernetes.io/name=common-instancetypes"

sleep 5

pei "# "
pei "# For this demo we only care about the server.micro VirtualMachineClusterInstancetype and cirros VirtualMachineClusterPreference:"
pei "# "
pei "./_kubevirt/cluster-up/kubectl.sh get virtualmachineclusterinstancetype/server.micro -o json | jq .spec"
pei "./_kubevirt/cluster-up/kubectl.sh get virtualmachineclusterpreference/cirros -o json | jq .spec"

pei "# "
pei "# The following example VirtualMachine is using inferFromVolume for both preferences and instance type:"
pei "# "
pei "yq . ${demoDir}/vm-cirros-ds.yaml"

sleep 5

pei "./_kubevirt/cluster-up/kubectl.sh apply -f ${demoDir}/vm-cirros-ds.yaml"

pei "# "
pei "# Once created we now see that the VirtualMachine mutation webhook has inferred the defaults from the DataSource labels and rewritten the {Instancetype,Preference}Matcher."
pei "# "
pei "./_kubevirt/cluster-up/kubectl.sh get vms/vm-cirros-ds -o json | jq '.spec.instancetype,.spec.preference'"

sleep 5

pei "# "
pei "# The eventual VMI is then created successfully with the expanded VirtualMachineInstanceSpec"
pei "# "

pei "./_kubevirt/cluster-up/kubectl.sh wait vms/vm-cirros-ds --for=condition=Ready --timeout 60s"
pei "diff --color -u <( ./_kubevirt/cluster-up/kubectl.sh get vms/vm-cirros-ds -o json | jq .spec.template.spec) <( ./_kubevirt/cluster-up/kubectl.sh get vmis/vm-cirros-ds -o json | jq .spec)" 

sleep 5

cd ${demoDir}