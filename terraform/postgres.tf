resource "random_string" "password" {
  length = 10
  special = false
}

resource "kubernetes_secret" "db-secret" {
  metadata {
    name = "db-password"
    namespace = "weather"
  }
  data {
    postgresql-password = "${random_string.password.result}"
  }

  depends_on = ["kubernetes_namespace.weather"]
}

locals {
  database-name = "weather"
}

resource "helm_release" "db" {
  name  = "weather"
  namespace = "weather"
  chart = "stable/postgresql"


  set {
    name = "existingSecret"
    value = "${kubernetes_secret.db-secret.metadata.0.name}"
  }

  set {
    name = "persistence.size"
    value = "1Gi"
  }

  set = {
    name  = "postgresqlDatabase"
    value = "${local.database-name}"
  }

  depends_on = ["kubernetes_secret.db-secret"]

}

