pei "# Demo 2. AutoattachInputDevice and PreferredAutoattachInputDevice"
pei "#"
pei "# Demo 2.1 AutoattachInputDevice has been introduced to Devices to automatically attach an input device"

pei "./cluster-up/kubectl.sh apply -f examples/csmall.yaml"

pei "yq . ${demoDir}/vm-demo-autoattachinputdevice.yaml"

pei "./cluster-up/kubectl.sh apply -f ${demoDir}/vm-demo-autoattachinputdevice.yaml" 

pei "# This results in a default input device being added to the VirtualMachineInstance at launch"
pei "./cluster-up/kubectl.sh get vmis/demo-autoattachinputdevice -o json  | jq .spec.domain.devices.inputs"

pei "# Demo 2.2 A new PreferredAutoattachInputDevice preference has been introduced to control this behaviour"
pei "#"
pei "# We can also control the type and bus of the input device through existing PreferredInputType and PreferredInputBus preferences:"
pei "yq . ${demoDir}/preference-preferredinputdevice.yaml"

pei "yq . ${demoDir}/vm-demo-preferredinputdevice.yaml"

pei "./cluster-up/kubectl.sh apply -f ${demoDir}/preference-preferredinputdevice.yaml -f ${demoDir}/vm-demo-preferredinputdevice.yaml" 

pei "./cluster-up/kubectl.sh get vms/demo-preferredinputdevice -o json  | jq .spec.template.spec.domain.devices"

pei "./cluster-up/kubectl.sh get vmis/demo-preferredinputdevice -o json  | jq .spec.domain.devices.autoattachInputDevice"

pei "./cluster-up/kubectl.sh get vmis/demo-preferredinputdevice -o json  | jq .spec.domain.devices.inputs"
