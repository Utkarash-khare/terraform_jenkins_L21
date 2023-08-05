# terraform.tfvars

# The GCP project to use for integration tests
project_id = "my-project-11-06-23"

# The GCP region to create and test resources in
region = "us-central1"

# The GCP zone to create resources in
zone = "us-central1-a"

# The subnetwork selflink to host the compute instances in
subnetwork = "projects/my-project-11-06-23/regions/us-central1/subnetworks/default"

# Number of instances to create
num_instances = 1

# Network network_tier
network_tier = "STANDARD"

hostname = jenikns-instance-dev

# Service account to attach to the instance.
# Uncomment and provide values if needed, otherwise, leave it as it is (null).
 service_account = {
   email = "terraform-service-account@my-project-11-06-23.iam.gserviceaccount.com"
   scopes =  [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/compute"
  ]
 }
