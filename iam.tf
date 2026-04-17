locals {
  project    = "project-d318db8d-3948-41a2-88d"
  sa_email   = "github-wif@${local.project}.iam.gserviceaccount.com"
  wif_member = "principalSet://iam.googleapis.com/projects/415090109691/locations/global/workloadIdentityPools/github-pool/attribute.repository/sherif-nassif/gcp-terraform-gh"
}

# Project-level roles for the service account
resource "google_project_iam_member" "compute_admin" {
  project = local.project
  role    = "roles/compute.admin"
  member  = "serviceAccount:${local.sa_email}"
}

resource "google_project_iam_member" "storage_admin" {
  project = local.project
  role    = "roles/storage.admin"
  member  = "serviceAccount:${local.sa_email}"
}

# Service account-level bindings for WIF impersonation
resource "google_service_account_iam_member" "wif_token_creator" {
  service_account_id = "projects/${local.project}/serviceAccounts/${local.sa_email}"
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = local.wif_member
}

resource "google_service_account_iam_member" "wif_workload_identity_user" {
  service_account_id = "projects/${local.project}/serviceAccounts/${local.sa_email}"
  role               = "roles/iam.workloadIdentityUser"
  member             = local.wif_member
}
