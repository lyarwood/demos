# The following demo used the following ENV:
export KUBEVIRT_PROVIDER=k8s-1.24
export KUBEVIRT_MEMORY_SIZE=$((1024 * 16))
export PS1="\[$IYellow\]# \[$IWhite\]"
#
# ██╗  ██╗██╗   ██╗██████╗ ███████╗██╗   ██╗██╗██████╗ ████████╗                                                                                                                                                                
# ██║ ██╔╝██║   ██║██╔══██╗██╔════╝██║   ██║██║██╔══██╗╚══██╔══╝                                                                                                                                                                
# █████╔╝ ██║   ██║██████╔╝█████╗  ██║   ██║██║██████╔╝   ██║                                                                                                                                                                   
# ██╔═██╗ ██║   ██║██╔══██╗██╔══╝  ╚██╗ ██╔╝██║██╔══██╗   ██║                                                                                                                                                                   
# ██║  ██╗╚██████╔╝██████╔╝███████╗ ╚████╔╝ ██║██║  ██║   ██║                                                                                                                                                                   
# ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝  ╚═══╝  ╚═╝╚═╝  ╚═╝   ╚═╝                                                                                                                                                                   
#                                                                                                                                                                                                                               
# ██╗███╗   ██╗███████╗████████╗ █████╗ ███╗   ██╗ ██████╗███████╗████████╗██╗   ██╗██████╗ ███████╗     █████╗ ███╗   ██╗██████╗     ██████╗ ██████╗ ███████╗███████╗███████╗██████╗ ███████╗███╗   ██╗ ██████╗███████╗███████╗
# ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗████╗  ██║██╔════╝██╔════╝╚══██╔══╝╚██╗ ██╔╝██╔══██╗██╔════╝    ██╔══██╗████╗  ██║██╔══██╗    ██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝██╔══██╗██╔════╝████╗  ██║██╔════╝██╔════╝██╔════╝
# ██║██╔██╗ ██║███████╗   ██║   ███████║██╔██╗ ██║██║     █████╗     ██║    ╚████╔╝ ██████╔╝█████╗      ███████║██╔██╗ ██║██║  ██║    ██████╔╝██████╔╝█████╗  █████╗  █████╗  ██████╔╝█████╗  ██╔██╗ ██║██║     █████╗  ███████╗
# ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║╚██╗██║██║     ██╔══╝     ██║     ╚██╔╝  ██╔═══╝ ██╔══╝      ██╔══██║██║╚██╗██║██║  ██║    ██╔═══╝ ██╔══██╗██╔══╝  ██╔══╝  ██╔══╝  ██╔══██╗██╔══╝  ██║╚██╗██║██║     ██╔══╝  ╚════██║
# ██║██║ ╚████║███████║   ██║   ██║  ██║██║ ╚████║╚██████╗███████╗   ██║      ██║   ██║     ███████╗    ██║  ██║██║ ╚████║██████╔╝    ██║     ██║  ██║███████╗██║     ███████╗██║  ██║███████╗██║ ╚████║╚██████╗███████╗███████║
# ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝   ╚═╝      ╚═╝   ╚═╝     ╚══════╝    ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝     ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚══════╝
#                                                                                                                                                                                                                               
# ██████╗ ███████╗███╗   ███╗ ██████╗      ██╗ ██╗ ██████╗                                                                                                                                                                      
# ██╔══██╗██╔════╝████╗ ████║██╔═══██╗    ████████╗╚════██╗                                                                                                                                                                     
# ██║  ██║█████╗  ██╔████╔██║██║   ██║    ╚██╔═██╔╝ █████╔╝                                                                                                                                                                     
# ██║  ██║██╔══╝  ██║╚██╔╝██║██║   ██║    ████████╗██╔═══╝                                                                                                                                                                      
# ██████╔╝███████╗██║ ╚═╝ ██║╚██████╔╝    ╚██╔═██╔╝███████╗                                                                                                                                                                     
# ╚═════╝ ╚══════╝╚═╝     ╚═╝ ╚═════╝      ╚═╝ ╚═╝ ╚══════╝ 
#
# Agenda
# 1. The Basics
# 2. VirtualMachineClusterInstancetype and VirtualMachineClusterPreference
# 3. VirtualMachineInstancetype vs VirtualMachinePreference vs VirtualMachine
# 4. Versioning
# 5. What's next... 
#    - https://github.com/kubevirt/kubevirt/issues/7897
#    - https://blog.yarwood.me.uk/2022/07/21/kubevirt_instancetype_update_2/


#
# Demo #1 The Basics

#
# Lets start by creating a simple namespaced VirtualMachineInstancetype, VirtualMachinePreference and VirtualMachine
cat <<EOF | ./cluster-up/kubectl.sh apply -f -
---
apiVersion: instancetype.kubevirt.io/v1alpha1
kind: VirtualMachineInstancetype
metadata:
  name: small
spec:
  cpu:
    guest: 2
  memory:
    guest: 128Mi
---
apiVersion: instancetype.kubevirt.io/v1alpha1
kind: VirtualMachinePreference
metadata:
  name: cirros
spec:
  devices:
    preferredDiskBus: virtio
    preferredInterfaceModel: virtio
---
apiVersion: kubevirt.io/v1
kind: VirtualMachine
metadata:
  name: demo
spec:
  instancetype:
    kind: VirtualMachineInstancetype
    name: small
  preference:
    kind: VirtualMachinePreference
    name: cirros
  running: false
  template:
    spec:
      domain:
        devices: {}
      volumes:
      - containerDisk:
          image: registry:5000/kubevirt/cirros-container-disk-demo:devel
        name: containerdisk
      - cloudInitNoCloud:
          userData: |
            #!/bin/sh

            echo 'printed from cloud-init userdata'
        name: cloudinitdisk
EOF

#
# Starting the VirtualMachine applies the VirtualMachineInstancetype and VirtualMachinePreference to the VirtualMachineInstance
./cluster-up/virtctl.sh start demo &&  ./cluster-up/kubectl.sh wait vms/demo --for=condition=Ready

#
# We can check this by comparing the two VirtualMachineInstanceSpec fields from the VirualMachine and VirtualMachineInstance
diff --color -u <( ./cluster-up/kubectl.sh get vms/demo -o json | jq .spec.template.spec) <( ./cluster-up/kubectl.sh get vmis/demo -o json | jq .spec)

#
# Demo #2 Cluster wide CRDs

#
# We also have cluster wide instancetypes and preferences we can use, note these are the default if no kind is provided within the VirtualMachine.
cat <<EOF | ./cluster-up/kubectl.sh apply -f -
---
apiVersion: instancetype.kubevirt.io/v1alpha1
kind: VirtualMachineClusterInstancetype
metadata:
  name: small-cluster
spec:
  cpu:
    guest: 2
  memory:
    guest: 128Mi
---
apiVersion: instancetype.kubevirt.io/v1alpha1
kind: VirtualMachineClusterPreference
metadata:
  name: cirros-cluster
spec:
  devices:
    preferredDiskBus: virtio
    preferredInterfaceModel: virtio
---
apiVersion: kubevirt.io/v1
kind: VirtualMachine
metadata:
  name: demo-cluster
spec:
  instancetype:
    name: small-cluster
  preference:
    name: cirros-cluster
  running: false
  template:
    spec:
      domain:
        devices: {}
      volumes:
      - containerDisk:
          image: registry:5000/kubevirt/cirros-container-disk-demo:devel
        name: containerdisk
      - cloudInitNoCloud:
          userData: |
            #!/bin/sh

            echo 'printed from cloud-init userdata'
        name: cloudinitdisk
EOF

#
# InstancetypeMatcher and PreferenceMatcher default to the Cluster CRD Kinds
./cluster-up/kubectl.sh get vms/demo-cluster -o json | jq '.spec.instancetype, .spec.preference'

 ./cluster-up/virtctl.sh start demo-cluster &&  ./cluster-up/kubectl.sh wait vms/demo-cluster --for=condition=Ready
diff --color -u <( ./cluster-up/kubectl.sh get vms/demo-cluster -o json | jq .spec.template.spec) <( ./cluster-up/kubectl.sh get vmis/demo-cluster -o json | jq .spec)

#
# Demo #3 Instancetypes vs Preferences vs VirtualMachine

#
# Users cannot overwrite anything set by an instancetype in their VirtualMachine, for example CPU topologies
cat <<EOF | ./cluster-up/kubectl.sh apply -f -
---
apiVersion: kubevirt.io/v1
kind: VirtualMachine
metadata:
  name: demo-instancetype-conflict
spec:
  instancetype:
    kind: VirtualMachineInstancetype
    name: small
  preference:
    kind: VirtualMachinePreference
    name: cirros
  running: false
  template:
    spec:
      domain:
        cpu:
          threads: 1
          cores: 3
          sockets: 1
        devices: {}
      volumes:
      - containerDisk:
          image: registry:5000/kubevirt/cirros-container-disk-demo:devel
        name: containerdisk
      - cloudInitNoCloud:
          userData: |
            #!/bin/sh

            echo 'printed from cloud-init userdata'
        name: cloudinitdisk
EOF

#
# Users can however overwrite anything set by a preference in their VirtualMachine, for example disk buses etc.
cat <<EOF | ./cluster-up/kubectl.sh apply -f -
---
apiVersion: kubevirt.io/v1
kind: VirtualMachine
metadata:
  name: demo-instancetype-user-preference
spec:
  instancetype:
    kind: VirtualMachineInstancetype
    name: small
  preference:
    kind: VirtualMachinePreference
    name: cirros
  running: false
  template:
    spec:
      domain:
        devices:
          disks:
          - disk:
              bus: sata
            name: containerdisk
      volumes:
      - containerDisk:
          image: registry:5000/kubevirt/cirros-container-disk-demo:devel
        name: containerdisk
      - cloudInitNoCloud:
          userData: |
            #!/bin/sh

            echo 'printed from cloud-init userdata'
        name: cloudinitdisk
EOF

./cluster-up/virtctl.sh start demo-instancetype-user-preference && ./cluster-up/kubectl.sh wait vms/demo-instancetype-user-preference --for=condition=Ready
diff --color -u <( ./cluster-up/kubectl.sh get vms/demo-instancetype-user-preference -o json | jq .spec.template.spec) <( ./cluster-up/kubectl.sh get vmis/demo-instancetype-user-preference -o json | jq .spec)

#
# Demo #4 Versioning

#
# We have versioning of instancetypes and preferences, note that the InstancetypeMatcher and PreferenceMatcher now have a populated revisionName field
./cluster-up/kubectl.sh get vms/demo -o json | jq '.spec.instancetype, .spec.preference'

#
# These are the names of ControllerRevisions containing a copy of the VirtualMachine{Instancetype,Preference}Spec at the time of application
./cluster-up/kubectl.sh get controllerrevisions/$( ./cluster-up/kubectl.sh get vms/demo -o json | jq .spec.instancetype.revisionName |  tr -d '"') -o json | jq .
./cluster-up/kubectl.sh get controllerrevisions/$( ./cluster-up/kubectl.sh get vms/demo -o json | jq .spec.preference.revisionName | tr -d '"') -o json | jq .


# With versioning we can update the VirtualMachineInstancetype, create a new VirtualMachine to assert the changes and then check that our original VirtualMachine hasn't changed
cat <<EOF | ./cluster-up/kubectl.sh apply -f -
---
apiVersion: instancetype.kubevirt.io/v1alpha1
kind: VirtualMachineInstancetype
metadata:
  name: small
spec:
  cpu:
    guest: 3
  memory:
    guest: 256Mi
---
apiVersion: instancetype.kubevirt.io/v1alpha1
kind: VirtualMachinePreference
metadata:
  name: cirros
spec:
  cpu:
    preferredCPUTopology: preferCores
  devices:
    preferredDiskBus: virtio
    preferredInterfaceModel: virtio
---
apiVersion: kubevirt.io/v1
kind: VirtualMachine
metadata:
  name: demo-updated
spec:
  instancetype:
    kind: VirtualMachineInstancetype
    name: small
  preference:
    kind: VirtualMachinePreference
    name: cirros
  running: false
  template:
    spec:
      domain:
        devices: {}
      volumes:
      - containerDisk:
          image: registry:5000/kubevirt/cirros-container-disk-demo:devel
        name: containerdisk
      - cloudInitNoCloud:
          userData: |
            #!/bin/sh

            echo 'printed from cloud-init userdata'
        name: cloudinitdisk
EOF

#
# Now start the updated VirtualMachine
./cluster-up/virtctl.sh start demo-updated &&  ./cluster-up/kubectl.sh wait vms/demo-updated --for=condition=Ready

#
# We now see the updated instancetype used by the new VirtualMachine and applied to the VirtualMachineInstance
diff --color -u <( ./cluster-up/kubectl.sh get vms/demo-updated -o json | jq .spec.template.spec) <( ./cluster-up/kubectl.sh get vmis/demo-updated -o json | jq .spec)

#
# With new ControllerRevisions referenced from the underlying VirtualMachine
./cluster-up/kubectl.sh get vms/demo-updated -o json | jq '.spec.instancetype, .spec.preference'

#
# We can also stop and start the original VirtualMachine without changing the VirtualMachineInstance it spawns
./cluster-up/virtctl.sh stop demo &&  ./cluster-up/kubectl.sh wait vms/demo --for=condition=Ready=false
./cluster-up/virtctl.sh start demo &&  ./cluster-up/kubectl.sh wait vms/demo --for=condition=Ready
diff --color -u <( ./cluster-up/kubectl.sh get vms/demo -o json | jq .spec.template.spec) <( ./cluster-up/kubectl.sh get vmis/demo -o json | jq .spec)

#
# The ControllerRevisions are owned by the VirtualMachines, as such removal of the VirtualMachines now removes the ControllerRevisions
./cluster-up/kubectl.sh get controllerrevisions
./cluster-up/kubectl.sh delete vms/demo vms/demo-updated vms/demo-cluster vms/demo-instancetype-user-preference
./cluster-up/kubectl.sh get controllerrevisions
