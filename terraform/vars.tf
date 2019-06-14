variable "digitalocean_token" {
  description = "The digitalocean access token secret"
}

variable "weather_image_version" {
  default = "0.0.1"
  description = "Image version for weather forecast"
}

variable "docker_user" {
  description = "User for container registry"
}

variable "docker_password" {
  description = "User for container registry"
}

variable "lets_encrypt_email" {
  description = "The email address to use when creating certificates with let's encrypt"
}

variable "weather_master_key" {
  description = "Master Key for rails app"
}
