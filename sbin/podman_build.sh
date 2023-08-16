#!/usr/bin/env bash

if [[ -z "$IMAGE" ]] || [[ -z "$BASE_DIR" ]]; then
    echo "Environment variables (BASE_DIR, IMAGE...) are not set! You need to load the config first with: $ source sbin/config.sh" 1>&2
    exit 1
fi

if [ -f "$IMAGE" ]; then
    echo "Image file ($IMAGE) exists already."
    exit 1
fi

srun -p $DEFAULT_PARTITION --mem=180G \
    --container-image=/netscratch/enroot/podman+enroot.sqsh \
    --container-mounts=/dev/fuse:/dev/fuse,/netscratch/$USER:/netscratch/$USER,$BASE_DIR:$BASE_DIR \
    --container-workdir=$BASE_DIR \
    --export BASE_DIR,IMAGE bash -c 'echo "Building image on $HOSTNAME in $BASE_DIR with output = $IMAGE"; podman build --isolation=chroot -t temp .; export ENROOT_SQUASH_OPTIONS="-comp lz4 -Xhc -b 262144"; enroot import -o $IMAGE podman://temp'
