apt-get update
apt-get install -y kubectl

gcloud container clusters get-credentials cluster-1 --region asia-south1 --project bustling-syntax-349005
    
kubectl apply -f depl.yaml
