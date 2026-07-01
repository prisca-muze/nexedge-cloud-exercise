variable project_id {
  description = "The GCP project ID"
  type        = string
}

variable region {
  description = "The GCP Primary region"
  type        = string
}

variable team_folders {
  description = "List of team folders to be created inside ebuisness"
  type        = list(string)
}

variable ebusiness_folder_id {
  description = "The ID of the ebusiness folder"
  type        = string
}

variable region1 {
  description = "The GCP region for the first subnet"
  type        = string
}

variable region2 {
  description = "The GCP region for the second subnet"
  type        = string
}

variable subnet_1_cidr {
  description = "The IP CIDR range for the first subnet"
  type        = string
}

variable subnet_2_cidr {
  description = "The IP CIDR range for the second subnet"
  type        = string
}

variable machine_type {
  description = "The machine type for the GCP instances"
  type        = string
}

variable gcp_ssh_username {
  description = "The username for SSH access to the GCP instances"
  type        = string
}

variable gcp_ssh_public_key {
  description = "The public SSH key for the GCP instances"
  type        = string
}

variable evaluator_email {
  description = "The email address of the evaluator for GCP"
  type        = string
}

variable database_tier {
  description = "The tier of the GCP database"
  type        = string
}

variable db_username {
  description = "The username for the GCP database"
  type        = string
}

variable db_password {
  description = "The password for the GCP database"
  type        = string
  sensitive   = true
}

variable node_count {
  description = "The number of nodes for the GKE node pool"
  type        = number
}

variable machine_type_GKE {
  description = "The machine type for the GKE node pool"
  type        = string
}

variable disk_size_gb {
  description = "The disk size for GKE node pool"
  type        = string
}

