image=$(jq -r '.spec.deployments[0].image' target/hello-world.json)

HA_STORAGE="file:///mnt/flink/storage/kha"

flink run-application \
    --target kubernetes-application \
    -Dkubernetes.cluster-id=hello-world \
    -Dkubernetes.service-account=flink-service-account \
    -Dkubernetes.container.image="$image" \
    -Dkubernetes.container.image.pull-policy=Always \
    -Dkubernetes.namespace=hello-world \
    -Dparallelism.default=2 \
    -Dhigh-availability=org.apache.flink.kubernetes.highavailability.KubernetesHaServicesFactory \
    -Dhigh-availability.storageDir="$HA_STORAGE" \
    -Dstate.checkpoints.dir="$HA_STORAGE" \
    -Dstate.savepoints.dir="$HA_STORAGE" \
    -Drestart-strategy=fixed-delay \
    -Drestart-strategy.fixed-delay.attempts=1 \
    -Dkubernetes.pod-template-file=pod-template.yaml \
    local:///opt/flink/usrlib/cloudflow-runner.jar
