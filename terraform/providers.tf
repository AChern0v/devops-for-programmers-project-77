terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.23.0"
    }
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

variable "datadog_api_key" {}
variable "datadog_app_key" {}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key

}
