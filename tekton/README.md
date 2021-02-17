1. Install Metric Server
   kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml

2. Install tekton
   kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

3. Need to LimitRanges in Namespace
