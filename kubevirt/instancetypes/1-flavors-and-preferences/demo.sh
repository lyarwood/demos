
export KUBEVIRT_PROVIDER=k8s-1.23
#
#  ██╗  ██╗██╗   ██╗██████╗ ███████╗██╗   ██╗██╗██████╗ ████████╗                                                                                                                        
#  ██║ ██╔╝██║   ██║██╔══██╗██╔════╝██║   ██║██║██╔══██╗╚══██╔══╝                                                                                                                        
#  █████╔╝ ██║   ██║██████╔╝█████╗  ██║   ██║██║██████╔╝   ██║                                                                                                                           
#  ██╔═██╗ ██║   ██║██╔══██╗██╔══╝  ╚██╗ ██╔╝██║██╔══██╗   ██║                                                                                                                           
#  ██║  ██╗╚██████╔╝██████╔╝███████╗ ╚████╔╝ ██║██║  ██║   ██║                                                                                                                           
#  ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝  ╚═══╝  ╚═╝╚═╝  ╚═╝   ╚═╝                                                                                                                           
#                                                                                                                                                                                        
#  ███████╗██╗      █████╗ ██╗   ██╗ ██████╗ ██████╗ ███████╗     █████╗ ███╗   ██╗██████╗     ██████╗ ██████╗ ███████╗███████╗███████╗██████╗ ███████╗███╗   ██╗ ██████╗███████╗███████╗
#  ██╔════╝██║     ██╔══██╗██║   ██║██╔═══██╗██╔══██╗██╔════╝    ██╔══██╗████╗  ██║██╔══██╗    ██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝██╔══██╗██╔════╝████╗  ██║██╔════╝██╔════╝██╔════╝
#  █████╗  ██║     ███████║██║   ██║██║   ██║██████╔╝███████╗    ███████║██╔██╗ ██║██║  ██║    ██████╔╝██████╔╝█████╗  █████╗  █████╗  ██████╔╝█████╗  ██╔██╗ ██║██║     █████╗  ███████╗
#  ██╔══╝  ██║     ██╔══██║╚██╗ ██╔╝██║   ██║██╔══██╗╚════██║    ██╔══██║██║╚██╗██║██║  ██║    ██╔═══╝ ██╔══██╗██╔══╝  ██╔══╝  ██╔══╝  ██╔══██╗██╔══╝  ██║╚██╗██║██║     ██╔══╝  ╚════██║
#  ██║     ███████╗██║  ██║ ╚████╔╝ ╚██████╔╝██║  ██║███████║    ██║  ██║██║ ╚████║██████╔╝    ██║     ██║  ██║███████╗██║     ███████╗██║  ██║███████╗██║ ╚████║╚██████╗███████╗███████║
#  ╚═╝     ╚══════╝╚═╝  ╚═╝  ╚═══╝   ╚═════╝ ╚═╝  ╚═╝╚══════╝    ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝     ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚══════╝                                                                                                                                                                                      
#
#  ██████╗ ███████╗███╗   ███╗ ██████╗ 
#  ██╔══██╗██╔════╝████╗ ████║██╔═══██╗
#  ██║  ██║█████╗  ██╔████╔██║██║   ██║
#  ██║  ██║██╔══╝  ██║╚██╔╝██║██║   ██║
#  ██████╔╝███████╗██║ ╚═╝ ██║╚██████╔╝
#  ╚═════╝ ╚══════╝╚═╝     ╚═╝ ╚═════╝
#
#
# Caveats!
# - Rename of the CRDs s/VirtualMachineFlavor/VirtualMachineInstanceType/g s/VirtualMachinePreference/VirtualMachineInstancePreference/g incoming before betav1.
# - This demo is using an unmerged versioning PR https://github.com/kubevirt/kubevirt/pull/7875
#   * Delayed due to the removal of flavor and preference informers https://github.com/kubevirt/kubevirt/pull/7935 not landing
#
# Agenda
# 1. The basics
# 2. Cluster wide CRDs
# 3. Flavors vs Preferences vs VirtualMachine
# 4. Versioning with ControllerRevisions

git log -n1 HEAD


#
# Demo #1 The basics

#
# Lets start by creating a simple namespaced VirtualMachineFlavor, VirtualMachinePreference and VirtualMachine
cat <<EOF | ./cluster-up/kubectl.sh apply -f -
---
apiVersion: flavor.kubevirt.io/v1alpha1
kind: VirtualMachineFlavor
metadata:
  name: small
spec:
  cpu:
    guest: 2
  memory:
    guest: 128Mi
---
apiVersion: flavor.kubevirt.io/v1alpha1
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
  flavor:
    kind: VirtualMachineFlavor
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
# Starting the VirtualMachine applies the VirtualMachineFlavor and VirtualMachinePreference to the VirtualMachineInstance
./cluster-up/virtctl.sh start demo &&  ./cluster-up/kubectl.sh wait vms/demo --for=condition=Ready

#
# We can check this by comparing the two VirtualMachineInstanceSpec fields from the VirualMachine and VirtualMachineInstance
diff --color -u <( ./cluster-up/kubectl.sh get vms/demo -o json | jq .spec.template.spec) <( ./cluster-up/kubectl.sh get vmis/demo -o json | jq .spec)

#
# Demo #2 Cluster wide CRDs

#
# We also have cluster wide flavors and preferences we can use
cat <<EOF | ./cluster-up/kubectl.sh apply -f -
---
apiVersion: flavor.kubevirt.io/v1alpha1
kind: VirtualMachineClusterFlavor
metadata:
  name: small-cluster
spec:
  cpu:
    guest: 2
  memory:
    guest: 128Mi
---
apiVersion: flavor.kubevirt.io/v1alpha1
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
  flavor:
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

# FlavorMatcher and PreferenceMatcher default to the Cluster CRD Kinds
./cluster-up/kubectl.sh get vms/demo-cluster -o json | jq '.spec.flavor, .spec.preference'

 ./cluster-up/virtctl.sh start demo-cluster &&  ./cluster-up/kubectl.sh wait vms/demo-cluster --for=condition=Ready
diff --color -u <( ./cluster-up/kubectl.sh get vms/demo-cluster -o json | jq .spec.template.spec) <( ./cluster-up/kubectl.sh get vmis/demo-cluster -o json | jq .spec)

#
# Demo #3 Flavors vs Preferences vs VirtualMachine

#
# Users cannot overwrite anything set by a flavor in their VirtualMachine, for example CPU topologies
cat <<EOF | ./cluster-up/kubectl.sh apply -f -
---
apiVersion: kubevirt.io/v1
kind: VirtualMachine
metadata:
  name: demo-flavor-conflict
spec:
  flavor:
    kind: VirtualMachineFlavor
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
  name: demo-flavor-user-preference
spec:
  flavor:
    kind: VirtualMachineFlavor
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

./cluster-up/virtctl.sh start demo-flavor-user-preference && ./cluster-up/kubectl.sh wait vms/demo-flavor-user-preference --for=condition=Ready
diff --color -u <( ./cluster-up/kubectl.sh get vms/demo-flavor-user-preference -o json | jq .spec.template.spec) <( ./cluster-up/kubectl.sh get vmis/demo-flavor-user-preference -o json | jq .spec)

#
# Demo #4 Versioning

#
# We now have versioning of flavors and preferences, note that the FlavorMatcher and PreferenceMatcher now have a populated revisionName field
./cluster-up/kubectl.sh get vms/demo -o json | jq '.spec.flavor, .spec.preference'

##
# These are the names of ControllerRevisions containing a copy of the VirtualMachine{Flavor,Preference}Spec at the time of application
./cluster-up/kubectl.sh get controllerrevisions/$( ./cluster-up/kubectl.sh get vms/demo -o json | jq .spec.flavor.revisionName |  tr -d '"') -o json | jq .
./cluster-up/kubectl.sh get controllerrevisions/$( ./cluster-up/kubectl.sh get vms/demo -o json | jq .spec.preference.revisionName | tr -d '"') -o json | jq .


# With versioning we can update the VirtualMachineFlavor, create a new VirtualMachine to assert the changes and then check that our original VirtualMachine hasn't changed
cat <<EOF | ./cluster-up/kubectl.sh apply -f -
---
apiVersion: flavor.kubevirt.io/v1alpha1
kind: VirtualMachineFlavor
metadata:
  name: small
spec:
  cpu:
    guest: 3
  memory:
    guest: 256Mi
---
apiVersion: flavor.kubevirt.io/v1alpha1
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
  flavor:
    kind: VirtualMachineFlavor
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
# We now see the updated flavor used by the new VirtualMachine and applied to the VirtualMachineInstance
diff --color -u <( ./cluster-up/kubectl.sh get vms/demo-updated -o json | jq .spec.template.spec) <( ./cluster-up/kubectl.sh get vmis/demo-updated -o json | jq .spec)

#
# With new ControllerRevisions referenced from the underlying VirtualMachine
./cluster-up/kubectl.sh get vms/demo-updated -o json | jq '.spec.flavor, .spec.preference'

#
# We can also stop and start the original VirtualMachine without changing the VirtualMachineInstance it spawns
./cluster-up/virtctl.sh stop demo &&  ./cluster-up/kubectl.sh wait vms/demo --for=condition=Ready=false
./cluster-up/virtctl.sh start demo &&  ./cluster-up/kubectl.sh wait vms/demo --for=condition=Ready
diff --color -u <( ./cluster-up/kubectl.sh get vms/demo -o json | jq .spec.template.spec) <( ./cluster-up/kubectl.sh get vmis/demo -o json | jq .spec)

#
# The ControllerRevisions are owned by the VirtualMachines, as such removal of the VirtualMachines now removes the ControllerRevisions
./cluster-up/kubectl.sh get controllerrevisions
./cluster-up/kubectl.sh delete vms/demo vms/demo-updated vms/demo-cluster vms/demo-flavor-user-preference
./cluster-up/kubectl.sh get controllerrevisions
