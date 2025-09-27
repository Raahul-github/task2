@echo off
echo Building and deploying Task API to Kubernetes...

echo Step 1: Building the Docker image
cd ..\task-api
call mvnw clean package
docker build -t task-api:1.0.0 .

echo Step 2: Deploying to Kubernetes
cd ..\task2-kubernetes
kubectl apply -f mongodb-pv.yaml
kubectl apply -f mongodb-deployment.yaml
kubectl apply -f task-api-deployment.yaml

echo Step 3: Checking deployment status
kubectl get pods
kubectl get services

echo Deployment complete! Use the following command to get the NodePort:
echo kubectl get svc task-api