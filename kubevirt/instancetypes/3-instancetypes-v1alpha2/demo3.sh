pei "# Demo 3. PreferredMachineType bugfix for https://github.com/kubevirt/kubevirt/issues/8338"

pei "yq . ${demoDir}/preference-preferredmachinetype.yaml"

pei "yq . ${demoDir}/vm-demo-preferredmachinetype.yaml"

pei "./cluster-up/kubectl.sh apply -f examples/csmall.yaml -f ${demoDir}/preference-preferredmachinetype.yaml -f ${demoDir}/vm-demo-preferredmachinetype.yaml"

pei "./cluster-up/kubectl.sh get vms/demo-preferredmachinetype -o json | jq .spec.template.spec.domain.machine"

pei "./cluster-up/kubectl.sh get vmis/demo-preferredmachinetype -o json | jq .spec.domain.machine"
