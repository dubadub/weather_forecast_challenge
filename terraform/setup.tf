data "terraform_remote_state" "common" {
  backend = "s3"

  config {
    bucket = "tf-state"
    key    = "common/main.tfstate"
    region = "us-west-1"
    endpoint = "https://ams3.digitaloceanspaces.com"
    skip_credentials_validation = true
    skip_get_ec2_platforms = true
    skip_requesting_account_id = true
    skip_metadata_api_check = true
    acl = "private"
  }
}

provider "digitalocean" {
  token = "${var.digitalocean_token}"
  version = "1.2.0"
}

data "digitalocean_kubernetes_cluster" "dubocluster" {
  name = "dubakube-terraform"
}

provider "kubernetes" {
  host = "${data.digitalocean_kubernetes_cluster.dubocluster.endpoint}"

  client_certificate     = "${base64decode(data.digitalocean_kubernetes_cluster.dubocluster.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(data.digitalocean_kubernetes_cluster.dubocluster.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(data.digitalocean_kubernetes_cluster.dubocluster.kube_config.0.cluster_ca_certificate)}"
  version = "1.6.2"
}

provider "helm" {
  service_account = "${data.terraform_remote_state.common.helm_tiller_service_account}"
  namespace       = "${data.terraform_remote_state.common.helm_tiller_namespace}"

  kubernetes {
    host = "${data.digitalocean_kubernetes_cluster.dubocluster.endpoint}"

    client_certificate     = "${base64decode(data.digitalocean_kubernetes_cluster.dubocluster.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(data.digitalocean_kubernetes_cluster.dubocluster.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(data.digitalocean_kubernetes_cluster.dubocluster.kube_config.0.cluster_ca_certificate)}"
  }
  version = "0.9.1"
}

locals {
  host = "weather.alexeydubovskoy.com"
}
