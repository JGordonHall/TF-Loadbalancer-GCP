terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.29.0"
    }
  }
}

provider "google" {
  credentials = file("terraform-key.json")
  project     = "class6-5-hw-456314"
  region      = "us-central1"
}