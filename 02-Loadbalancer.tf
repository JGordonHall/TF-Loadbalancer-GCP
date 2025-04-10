
resource "google_compute_instance" "web1" {
  name         = "web1"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = file("Skynet-Script.sh")
    

}

resource "google_compute_instance_group" "web_group" {
  name      = "web-instance-group"
  zone      = "us-central1-a"
  instances = [google_compute_instance.web1.self_link]
  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_health_check" "hc" {
  name = "http-health-check"
  http_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "backend" {
  name                  = "web-backend-service"
  load_balancing_scheme = "EXTERNAL"
  protocol              = "HTTP"
  health_checks         = [google_compute_health_check.hc.self_link]
  backend {
    group = google_compute_instance_group.web_group.self_link
  }
}

resource "google_compute_url_map" "url_map" {
  name            = "web-url-map"
  default_service = google_compute_backend_service.backend.self_link
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "web-http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

# Reference your existing global static IP
resource "google_compute_global_address" "existing_lb_ip" {
  name = "lb-ip-address"  # MUST match the name of the existing reserved IP
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name                  = "web-http-forwarding-rule"
  target                = google_compute_target_http_proxy.http_proxy.self_link
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.existing_lb_ip.address
}
