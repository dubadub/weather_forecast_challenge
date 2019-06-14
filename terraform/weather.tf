
resource "digitalocean_record" "www" {
  domain = "${data.terraform_remote_state.common.main_domain}"
  type   = "A"
  name   = "weather"
  value  = "${data.terraform_remote_state.common.public_ip}"
}

resource "kubernetes_namespace" "weather" {
  metadata {
    name = "weather"
  }
}

module "weather-prod-cert" {
  source = "git@github.com:dubadub/infrastructure.git//modules/cert-issuer"

  name = "weather-prod-cert"
  namespace = "${kubernetes_namespace.weather.metadata.0.name}"
  email = "${var.lets_encrypt_email}"

  depending_on = [
    "kubernetes_namespace.weather"
  ]
}

module "weather-ingress" {
  source = "git@github.com:dubadub/infrastructure.git//modules/ingress"

  name = "weather-ingress"
  service = "weather"
  namespace = "${kubernetes_namespace.weather.metadata.0.name}"
  certificate = "${module.weather-prod-cert.name}"
  host = "${local.host}"
  port = 3000
}

resource "kubernetes_service" "weather" {
  metadata {
    name = "weather"
    namespace = "${kubernetes_namespace.weather.metadata.0.name}"
  }

  spec {
    selector {
      app = "weather"
    }
    port {
      port = 3000
      target_port = 3000
    }
  }
}

module "registry-credentials" {
  source = "git@github.com:dubadub/infrastructure.git//modules/registry-credentials"

  name = "registry-secret"
  namespace = "${kubernetes_namespace.weather.metadata.0.name}"

  registry_endpoint = "${data.terraform_remote_state.common.registry_endpoint}"

  docker_user = "${var.docker_user}"
  docker_password = "${var.docker_password}"
}

resource "kubernetes_secret" "rails-master-key" {
  metadata {
    name = "rails-master-key"
    namespace = "weather"
  }
  data {
    rails-master-key = "${var.weather_master_key}"
  }
}


resource "kubernetes_deployment" "weather" {
  metadata {
    name = "weather"
    namespace = "${kubernetes_namespace.weather.metadata.0.name}"
    labels {
      app = "weather"
    }
  }

  depends_on = ["helm_release.db"]

  spec {
    replicas = 1

    strategy = {
      type = "Recreate"
    }

    selector {
      match_labels {
        app = "weather"
      }
    }

    template {
      metadata {
        labels {
          app = "weather"
        }
      }

      spec {
        init_container {
          image = "${data.terraform_remote_state.common.registry_endpoint}/weather:${var.weather_image_version}"
          name  = "weather-migrations"

          image_pull_policy = "Always"

          command = ["sh", "-c", "bundle exec rails db:migrate"]

          env {
            name = "DATABASE_NAME"
            value = "${local.database-name}"
          }

          env {
            name = "DATABASE_HOST"
            value = "${helm_release.db.name}-postgresql.weather.svc.cluster.local"
          }

          env {
            name = "DATABASE_USER"
            value = "postgres"
          }

          env {
            name = "DATABASE_PASSWORD"
            value_from {
              secret_key_ref {
                name = "${kubernetes_secret.db-secret.metadata.0.name}"
                key = "postgresql-password"
              }
            }
          }

          env {
            name = "RAILS_ENV"
            value = "production"
          }

          env {
            name = "RAILS_MASTER_KEY"
            value_from {
              secret_key_ref {
                name = "${kubernetes_secret.rails-master-key.metadata.0.name}"
                key = "rails-master-key"
              }
            }
          }

        }

        container {
          image = "${data.terraform_remote_state.common.registry_endpoint}/weather:${var.weather_image_version}"
          name  = "weather"

          port {
            container_port = 3000
          }

          image_pull_policy = "Always"

          env {
            name = "DATABASE_NAME"
            value = "${local.database-name}"
          }

          env {
            name = "DATABASE_HOST"
            value = "${helm_release.db.name}-postgresql.weather.svc.cluster.local"
          }

          env {
            name = "DATABASE_USER"
            value = "postgres"
          }

          env {
            name = "DATABASE_PASSWORD"
            value_from {
              secret_key_ref {
                name = "${kubernetes_secret.db-secret.metadata.0.name}"
                key = "postgresql-password"
              }
            }
          }

          env {
            name = "RAILS_ENV"
            value = "production"
          }

          env {
            name = "RAILS_MASTER_KEY"
            value_from {
              secret_key_ref {
                name = "${kubernetes_secret.rails-master-key.metadata.0.name}"
                key = "rails-master-key"
              }
            }
          }
        }


        image_pull_secrets {
          name = "${module.registry-credentials.name}"
        }
      }
    }
  }
}



