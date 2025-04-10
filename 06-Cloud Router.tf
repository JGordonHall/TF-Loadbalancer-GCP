# Cloud Router
resource "google_compute_router" "lb_router" {
  name    = "lb-cloud-router"
  region  = "us-central1"
  network = google_compute_network.lb_vpc.id
}
