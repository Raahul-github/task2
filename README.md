# Task 2: Kubernetes Deployment

This folder contains all the necessary files to deploy the Task API application to Kubernetes.

## Prerequisites

- Docker Desktop with Kubernetes enabled or Minikube
- kubectl command-line tool
- Java 17 and Maven (for building the application)

## Deployment Steps

### 1. Build the Docker Image

```bash
# Navigate to the task-api directory
cd ../task-api

# Build the application
./mvnw clean package

# Build the Docker image
docker build -t task-api:1.0.0 .
```

### 2. Deploy to Kubernetes

```bash
# Create the MongoDB persistent volume and claim
kubectl apply -f mongodb-pv.yaml

# Deploy MongoDB
kubectl apply -f mongodb-deployment.yaml

# Deploy the Task API
kubectl apply -f task-api-deployment.yaml

# Verify the deployments
kubectl get pods
kubectl get services
```

### 3. Access the Application

The Task API is exposed as a NodePort service. To access it:

```bash
# Get the NodePort assigned to the task-api service
kubectl get svc task-api

# Access the API (replace <NODE_PORT> with the actual port)
# If using Docker Desktop: http://localhost:<NODE_PORT>
# If using Minikube: http://$(minikube ip):<NODE_PORT>
```

## Testing the Application

### Create a Task

```bash
curl -X PUT http://localhost:<NODE_PORT>/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "id": "123",
    "name": "Print Hello",
    "owner": "John Smith",
    "command": "echo Hello World!"
  }'
```

### Execute a Task

```bash
curl -X PUT http://localhost:<NODE_PORT>/tasks/123/execute
```

This will create a new Kubernetes pod to run the command and capture its output.

### Get All Tasks

```bash
curl http://localhost:<NODE_PORT>/tasks
```

### Get a Task by ID

```bash
curl http://localhost:<NODE_PORT>/tasks?id=123
```

### Search Tasks by Name

```bash
curl http://localhost:<NODE_PORT>/tasks/search?name=Hello
```

### Delete a Task

```bash
curl -X DELETE http://localhost:<NODE_PORT>/tasks/123
```

## Implementation Details

- The Task API uses environment variables for MongoDB connection
- MongoDB data is stored in a persistent volume
- The Task API creates Kubernetes pods to execute commands
- Both services run in separate pods within the cluster
