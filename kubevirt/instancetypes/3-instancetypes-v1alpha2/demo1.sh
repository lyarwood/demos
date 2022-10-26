pei "# Demo 1. The new v1alpha2 API version"

pei "# This version introduces no changes for the user visible API/CRDs"

pei "yq . examples/csmall.yaml"

pei "yq . examples/vm-cirros-csmall.yaml"

pei "./cluster-up/kubectl.sh apply -f examples/csmall.yaml -f examples/vm-cirros-csmall.yaml" 

pei "# We now create ControllerRevisions as soon as the VirtualMachine is first seen by the VirtualMachine controller:"

pei "./cluster-up/kubectl.sh get vm/vm-cirros-csmall -o json | jq .spec.instancetype"

pei "# We now also capture complete VirtualMachine{Instancetype,ClusterInstancetype,Preference,ClusterPreference} objects within the ControllerRevisions"

pei "./cluster-up/kubectl.sh get controllerrevisions/$(./cluster-up/kubectl.sh get vm/vm-cirros-csmall -o json | jq -r .spec.instancetype.revisionName) -o json | jq ."
