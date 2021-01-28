brew install kind
kind create cluster --config config.yaml
kubectl apply -f https://k8s.io/examples/controllers/nginx-deployment.yaml
kubectl expose deployment nginx-deployment --type=NodePort --name=nginx-service
kubectl port-forward service/nginx-service 8000:80
kind delete cluster
