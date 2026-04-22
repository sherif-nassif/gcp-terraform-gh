resource "google_service_account" "github_wif" {
  account_id   = "github-wif"
  display_name = "GitHub WIF Service Account"
  project      = "project-d318db8d-3948-41a2-88d"

  lifecycle {
    ignore_changes = all
  }
}
