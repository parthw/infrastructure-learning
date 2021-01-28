# Kind

kind is a tool for running local Kubernetes clusters using Docker container “nodes”.
kind was primarily designed for testing Kubernetes itself, but may be used for local development or CI.

### To install kind in mac execute

brew install kind

### To create cluster execute

kind create cluster --config config.yaml

### To deploy nginx deployment execute

kubectl apply -f https://k8s.io/examples/controllers/nginx-deployment.yaml

### To expose the service execute

kubectl expose deployment nginx-deployment --type=NodePort --name=nginx-service

### To port forward the service execute

kubectl port-forward service/nginx-service 8000:80

### To delete the cluster execute

kind delete cluster
