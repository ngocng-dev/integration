#!/bin/bash -x

if [ -z "$WORKSPACE" ]; then
    export WORKSPACE=`git rev-parse --show-toplevel`
fi

source $WORKSPACE/test/ete/scripts/install_openstack_cli.sh

# skip use of multi-vim APIs for now
# delete all Proxy Designate DNS records; do this first since we rely on multi-vim for this
# $WORKSPACE/test/ete/scripts/dns-zones/delete-dns-zones.sh $OS_PROJECT_NAME
# sleep 1

# delete all Desigate DNS zones belonging to this project
ZONES=$(openstack zone list -c "id" -f value)
for ZONE in ${ZONES}; do
    ZONE_PROJECT_ID=$(openstack zone show $ZONE -f json | jq -r '.project_id')
    if [ "$OS_PROJECT_ID" == "$ZONE_PROJECT_ID" ]; then
        openstack zone delete $ZONE
    fi
done

# delete all instances
openstack server delete $(openstack server list -c ID -f value)
sleep 1

# miscellaneous cleanup
openstack floating ip delete $(openstack floating ip list -c ID -f value)
sleep 1

ROUTERS=$(openstack router list -c ID -f value)
echo $ROUTERS
for ROUTER in $ROUTERS; do
    echo $ROUTER;
    PORTS=$(openstack router show $ROUTER  -c "interfaces_info" -f "value" | jq -r '.[].port_id')
    for PORT in $PORTS; do
        openstack router remove port $ROUTER $PORT
    done
    openstack router delete $ROUTER
done

openstack port delete $(openstack port list -f value -c ID)
openstack volume delete $(openstack volume list -f value -c ID)

# delete all except "default" security group
SECURITY_GROUPS=$(openstack security group list -c ID -f value | grep -v default)
openstack security group delete $SECURITY_GROUPS
sleep 1


# Delete all existing stacks
STACKS=$(openstack stack list -c "Stack Name" -f value)

if [ ! -z "${STACKS}" ]; then
    openstack stack delete -y $STACKS
    for STACK in ${STACKS}; do
        until [ "DELETE_IN_PROGRESS" != "$(openstack stack show -c stack_status -f value $STACK)" ]; do
            sleep 2
        done
    done
else
    echo "No existing stacks to delete."
fi
