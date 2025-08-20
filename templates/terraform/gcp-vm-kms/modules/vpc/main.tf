resource "google_compute_network" "main" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "subnets" {
  count = length(var.subnets)
  
  project       = var.project_id
  name          = var.subnets[count.index].name
  ip_cidr_range = var.subnets[count.index].ip_cidr_range
  region        = var.subnets[count.index].region
  network       = google_compute_network.main.id

  # Enable private Google access
  private_ip_google_access = true

  # Enable flow logs for monitoring
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "rules" {
  count = length(var.firewall_rules)
  
  project   = var.project_id
  name      = var.firewall_rules[count.index].name
  network   = google_compute_network.main.name
  direction = var.firewall_rules[count.index].direction
  priority  = var.firewall_rules[count.index].priority

  source_ranges = var.firewall_rules[count.index].source_ranges
  target_tags   = var.firewall_rules[count.index].target_tags

  dynamic "allow" {
    for_each = var.firewall_rules[count.index].allow
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
}

# Router for NAT gateway (for private instances to access internet)
resource "google_compute_router" "router" {
  project = var.project_id
  name    = "${var.vpc_name}-router"
  region  = var.subnets[0].region
  network = google_compute_network.main.id
}

# NAT gateway
resource "google_compute_router_nat" "nat" {
  project = var.project_id
  name    = "${var.vpc_name}-nat"
  router  = google_compute_router.router.name
  region  = google_compute_router.router.region

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
