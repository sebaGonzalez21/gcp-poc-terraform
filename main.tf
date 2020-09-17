## saber que proveedor descargar, tambien asignar una version a cada proveedor
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 1.0"
    }
  }
}


provider "google" {
  version = "3.5.0"
  #credentials = file("Test-Proyect-ea7e1a06ed9a.json")

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

##Asignar direccion de ip statica
resource "google_compute_address" "vm_static_ip" {
    name = "terraform-static-ip"
}

## Se pueden añadir tags posteriormente
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  tags         = ["web", "dev"]
  
  ## Cambio de la imagen de dico, cambio destructivo
  boot_disk {
    initialize_params {
      #image = "debian-cloud/debian-9"
      image = "cos-cloud/cos-stable"
    }
  }

  ## parametros de redes para la instancia de compute engine
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      nat_ip = google_compute_address.vm_static_ip.address
    }
  }

  
}

