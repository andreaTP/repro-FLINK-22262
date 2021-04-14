image=$(jq -r '.spec.deployments[0].image' target/hello-world.json)

flink run-application \
    --target kubernetes-application \
    -Dkubernetes.cluster-id=hello-world \
    -Dkubernetes.service-account=flink-service-account \
    -Dkubernetes.container.image="$image" \
    -Dkubernetes.namespace=hello-world \
    -Dparallelism.default=2 \
    -Dhigh-availability=org.apache.flink.kubernetes.highavailability.KubernetesHaServicesFactory \
    -Dhigh-availability.storageDir=/mnt/flink/storage/asha \
    -Dkubernetes.pod-template-file=pod-template.yaml \
    local:///opt/flink/usrlib/cloudflow-runner.jar
