# -----------------------------------------------------
# GCP ORGANIZATION STRUCTURE
#------------------------------------------------------

# ---------------------------------------------------------
# create the following folders inside ebuisness: hub, ops, search, ordermanagement, businessintelligence, supplymanagement, productcreation, integration, omnichannel, consumerapp, customerselfservice, productpresentation, productinformation, dropshipment
# ---------------------------------------------------------
resource "google_folder" "team_folders" {
  for_each = toset(var.team_folders)
  display_name = each.value
  parent       = var.ebusiness_folder_id
  deletion_protection = false
}

# ------------------------------------------------------------------
# Create a custom VPC network with 2 subnets in different regions
# ------------------------------------------------------------------

# -------------------------
# A custom VPC network
# ------------------------
resource "google_compute_network" "cp_vpc" {
  name                    = "cp-vpc"
  auto_create_subnetworks = false
}

# -------------------------------
# Subnet 1
# -------------------------------
resource "google_compute_subnetwork" "cp_subnet_1" {
  name          = "cp-subnet-1"
  ip_cidr_range = var.subnet_1_cidr
  region        = var.region1
  network       = google_compute_network.cp_vpc.name
}

# -------------------------------
# Subnet 2
# -------------------------------
resource "google_compute_subnetwork" "cp_subnet_2" {
  name          = "cp-subnet-2"
  ip_cidr_range = var.subnet_2_cidr
  region        = var.region2
  network       = google_compute_network.cp_vpc.name
}

# ------------------------------------------------------
# CREATE VPC NETWORK
# ------------------------------------------------------

# ------------------------------------------------------
# Configure firewall rules to allow HTTP/HTTPS traffic and also allow SSH access from 0.0.0.0/0
# --------------------------------------------------------

# -------------------------------
# Allow HTTP and HTTPS traffic
# -------------------------------
resource "google_compute_firewall" "allow_http_https" {
  name    = "allow-http-https"
  network = google_compute_network.cp_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# ---------------------------------
# Allow SSH access from 0.0.0.0/0
# ---------------------------------
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.cp_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# ------------------------------------------------------
# PROVISION COMPUTE ENGINE VM INSTANCE
# ------------------------------------------------------

# ------------------------------------------------------
# Create two Compute Engine VM instance in the subnets with a public IP address and allow HTTP/HTTPS traffic and ssh access from 0.0.0.0/0
# ------------------------------------------------------

# ---------------------
# VM1
# ---------------------
resource "google_compute_instance" "cp_vm_instance" {
  name         = "cp-vm-instance"
  machine_type = var.machine_type
  zone         = "${var.region1}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.cp_subnet_1.name
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.gcp_ssh_username}:${var.gcp_ssh_public_key}"
  }
}

# ---------------------
# VM2
# ---------------------
resource "google_compute_instance" "cp_vm_instance_2" {
  name         = "cp-vm-instance-2"
  machine_type = var.machine_type
  zone         = "${var.region2}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.cp_subnet_2.name
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.gcp_ssh_username}:${var.gcp_ssh_public_key}"
  }
}

# ------------------------------------------------------
# SET UP IDENTITY AND ACCESS MANAGEMENT (IAM) ROLES
# ------------------------------------------------------

#------------------------------------------------------
# Grant Compute Network Admin in your project to ${var.evaluator_email}
# ------------------------------------------------------
resource "google_project_iam_member" "compute_network_admin" {
  project = var.project_id
  role    = "roles/compute.networkAdmin"
  member  = "user:${var.evaluator_email}"
}

# ------------------------------------------------------
# Grant Compute Admin in your project to ${var.evaluator_email}
# ------------------------------------------------------
resource "google_project_iam_member" "compute_admin" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "user:${var.evaluator_email}"
}

# ------------------------------------------------------
# DEPLOY A MANAGED DATABASE
# ------------------------------------------------------

# ------------------------------------------------------
# Set up a Cloud SQL (MySQL) database instance
# ------------------------------------------------------
resource "google_sql_database_instance" "cp_sql_instance" {
  name             = "cp-sql-instance"
  database_version = "MYSQL_8_0"
  region           = var.region
  deletion_protection = false

  settings {
    tier = var.database_tier

    ip_configuration {
      ipv4_enabled = true
    }
  }
}

resource "google_sql_user" "cp_sql_user" {
  name     = "cp-sql-user"
  instance = google_sql_database_instance.cp_sql_instance.name
  password = var.db_password
  host     = "%"
}

# ---------------------------------------
# PROVISION KUBERNETES CLUSTER
# ---------------------------------------

# ---------------------------------------
# A standard Kubernetes Cluster
# ---------------------------------------

# ---------------------------------------
# Create a Kubernetes cluster with the service account
# A Kubernetes cluster is a managed environment for deploying, managing, and scaling containerized applications using Google Kubernetes Engine (GKE).
# ---------------------------------------
resource "google_container_cluster" "cp_k8s_cluster" {
  name     = "cp-k8s-cluster"
  location = "${var.region}-b"
  deletion_protection = false

  release_channel {
    channel = "STABLE"
  }

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.cp_vpc.name
  subnetwork = google_compute_subnetwork.cp_subnet_1.name

}

# ---------------------------------------
# Create a node pool for the Kubernetes cluster
# A node pool is a group of nodes within a Kubernetes cluster that share the same configuration. The node pool will be used to run the containerized applications.
# ---------------------------------------
resource "google_container_node_pool" "cp_k8s_node_pool" {
  name       = "cp-k8s-node-pool"
  cluster    = google_container_cluster.cp_k8s_cluster.name
  location   = "${var.region}-b"
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type_GKE
    disk_size_gb = var.disk_size_gb
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}