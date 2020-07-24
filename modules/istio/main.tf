# istio

# istioctl manifest apply --set profile=demo --set values.kiali.dashboard.auth.strategy=anonymous

resource "helm_release" "kiali-gatekeeper" {
  repository = "https://gabibbo97.github.io/charts/"
  chart      = "keycloak-gatekeeper"
  version    = var.gabibbo97_keycloak_gatekeeper_version

  namespace = "istio-system"
  name      = "kiali-gatekeeper"

  values = [
    file("./modules/istio/values/kiali-gatekeeper.yaml")
  ]

  wait = false

  create_namespace = true

  depends_on = [
    var.module_depends_on
  ]
}

resource "helm_release" "tracing-gatekeeper" {
  repository = "https://gabibbo97.github.io/charts/"
  chart      = "keycloak-gatekeeper"
  version    = var.gabibbo97_keycloak_gatekeeper_version

  namespace = "istio-system"
  name      = "tracing-gatekeeper"

  values = [
    file("./modules/istio/values/tracing-gatekeeper.yaml")
  ]

  wait = false

  create_namespace = true

  depends_on = [
    var.module_depends_on
  ]
}