# Testing the Task API Kubernetes Deployment

This document provides step-by-step instructions for testing the Task API after deploying it to Kubernetes.

## Prerequisites

- Kubernetes cluster running (Docker Desktop, Minikube, etc.)
- kubectl configured to connect to your cluster
- Task API and MongoDB deployed using the provided manifests

## Getting the API Endpoint

```bash
# Get the NodePort for the Task API service
kubectl get svc task-api
```

Note the NodePort (e.g., 31234) and use it in the following commands.

## Test Cases

### 1. Create a Task

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

Expected response: A JSON object with the task details.

### 2. Execute a Task (This will create a Kubernetes pod)

```bash
curl -X PUT http://localhost:<NODE_PORT>/tasks/123/execute
```

Expected response: A JSON object with the task details including the execution results.

### 3. Verify Pod Creation

```bash
# Check if a pod was created for the task execution
kubectl get pods | grep task-exec
```

Expected result: You should see a pod with a name starting with "task-exec" (it might be in "Completed" state).

### 4. Get Task Details

```bash
curl http://localhost:<NODE_PORT>/tasks?id=123
```

Expected response: A JSON object with the task details including the execution results.

### 5. Test MongoDB Persistence

```bash
# Delete the MongoDB pod to test persistence
kubectl delete pod -l app=mongodb

# Wait for the pod to be recreated
kubectl get pods -l app=mongodb

# Get the task to verify data persistence
curl http://localhost:<NODE_PORT>/tasks?id=123
```

Expected result: The task data should still be available after the MongoDB pod is recreated.

## Troubleshooting

### Check Pod Logs

```bash
# For the Task API pod
kubectl logs -l app=task-api

# For the MongoDB pod
kubectl logs -l app=mongodb

# For a specific task execution pod
kubectl logs <task-exec-pod-name>
```

### Check Pod Status

```bash
kubectl describe pod -l app=task-api
kubectl describe pod -l app=mongodb
```

### Check Persistent Volume

```bash
kubectl get pv
kubectl get pvc
```

## Screenshots for Submission

Make sure to capture screenshots of:

1. The kubectl commands showing the running pods
2. The curl command output showing a successful API response
3. The pod list showing a task execution pod created by the API

These screenshots will serve as proof that your application is correctly deployed to Kubernetes and functioning as required.