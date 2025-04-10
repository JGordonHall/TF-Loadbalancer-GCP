# Cloud NAT
resource "google_compute_router_nat" "lb_nat" {
  name                               = "lb-cloud-nat"
  router                             = google_compute_router.lb_router.name
  region                             = google_compute_router.lb_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
