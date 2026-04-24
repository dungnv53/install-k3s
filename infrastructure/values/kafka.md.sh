#Docker.io or Dockerhub pull rate limit => try download manually
# Try the legacy path which often has higher availability for older tags
docker pull bitnamilegacy/kafka:3.6.0-debian-11-r2
# 1. Save the image to a tar file
docker save bitnamilegacy/kafka:3.6.0-debian-11-r2 > kafka.tar

# 2. Import it into MicroK8s
microk8s ctr image import kafka.tar

# 3. Clean up
rm kafka.tar


root@r1vn-automate:/home/r1vn-auto4/devops/devops-gitops# helmfile -f infrastructure/helmfile.yaml -l name=kafka sync
Adding repo argo https://argoproj.github.io/argo-helm
"argo" has been added to your repositories

Adding repo bitnami https://charts.bitnami.com/bitnami
"bitnami" has been added to your repositories

Adding repo harbor https://helm.goharbor.io
"harbor" has been added to your repositories

Adding repo jenkins https://charts.jenkins.io
"jenkins" has been added to your repositories

Adding repo jetstack https://charts.jetstack.io
"jetstack" has been added to your repositories

Adding repo rancher-latest https://releases.rancher.com/server-charts/latest
"rancher-latest" has been added to your repositories

Adding repo prometheus-community https://prometheus-community.github.io/helm-charts
"prometheus-community" has been added to your repositories

Adding repo sealed-secrets https://bitnami-labs.github.io/sealed-secrets
"sealed-secrets" has been added to your repositories

Upgrading release=kafka, chart=bitnami/kafka, namespace=kafka
Release "kafka" has been upgraded. Happy Helming!
NAME: kafka
LAST DEPLOYED: Thu Apr 23 04:05:02 2026
NAMESPACE: kafka
STATUS: deployed
REVISION: 4
TEST SUITE: None
NOTES:
CHART NAME: kafka
CHART VERSION: 26.4.3
APP VERSION: 3.6.0

** Please be patient while the chart is being deployed **

Kafka can be accessed by consumers via port 9092 on the following DNS name from within your cluster:

    kafka.kafka.svc.cluster.local

Each Kafka broker can be accessed by producers via port 9092 on the following DNS name(s) from within your cluster:

    kafka-controller-0.kafka-controller-headless.kafka.svc.cluster.local:9092
    kafka-controller-1.kafka-controller-headless.kafka.svc.cluster.local:9092
    kafka-controller-2.kafka-controller-headless.kafka.svc.cluster.local:9092

The CLIENT listener for Kafka client connections from within your cluster have been configured with the following security settings:
    - SASL authentication

To connect a client to your Kafka, you need to create the 'client.properties' configuration files with the content below:

security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-256
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required \
    username="user1" \
    password="$(kubectl get secret kafka-user-passwords --namespace kafka -o jsonpath='{.data.client-passwords}' | base64 -d | cut -d , -f 1)";

To create a pod that you can use as a Kafka client run the following commands:

    kubectl run kafka-client --restart='Never' --image public.ecr.aws/bitnami/kafka:3.6.0-debian-11-r2 --namespace kafka --command -- sleep infinity
    kubectl cp --namespace kafka /path/to/client.properties kafka-client:/tmp/client.properties
    kubectl exec --tty -i kafka-client --namespace kafka -- bash

    PRODUCER:
        kafka-console-producer.sh \
            --producer.config /tmp/client.properties \
            --broker-list kafka-controller-0.kafka-controller-headless.kafka.svc.cluster.local:9092,kafka-controller-1.kafka-controller-headless.kafka.svc.cluster.local:9092,kafka-controller-2.kafka-controller-headless.kafka.svc.cluster.local:9092 \
            --topic test

    CONSUMER:
        kafka-console-consumer.sh \
            --consumer.config /tmp/client.properties \
            --bootstrap-server kafka.kafka.svc.cluster.local:9092 \
            --topic test \
            --from-beginning

Listing releases matching ^kafka$
kafka	kafka    	4       	2026-04-23 04:05:02.804505567 +0000 UTC	deployed	kafka-26.4.3	3.6.0      


UPDATED RELEASES:
NAME    NAMESPACE   CHART           VERSION   DURATION
kafka   kafka       bitnami/kafka   26.4.3       1m39s

# Kafka resources hit limit

microk8s kubectl patch kafka dev-cluster -n kafka --type=merge -p '
{
  "spec": {
    "kafka": {
      "resources": {
        "requests": { "memory": "1Gi", "cpu": "250m" },
        "limits": { "memory": "1.5Gi", "cpu": "1" }
      }
    }
  }
}'
