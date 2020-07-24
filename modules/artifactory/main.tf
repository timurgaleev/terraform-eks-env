resource "helm_release" "chartmuseum" {
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "chartmuseum"
  version    = var.stable_chartmuseum_version

  namespace = "artifactory"
  name      = "chartmuseum"

  values = [
    file("./modules/artifactory/values/chartmuseum.yaml")
  ]

  wait = false

  create_namespace = true
}

resource "helm_release" "archiva" {
  repository = "https://xetus-oss.github.io/helm-charts/"
  chart      = "xetusoss-archiva"

  namespace = "artifactory"
  name      = "archiva"

  values = [
    file("./modules/artifactory/values/archiva.yaml")
  ]

  wait = false

  create_namespace = true

}

resource "helm_release" "sonatype-nexus" {

  repository = "https://oteemo.github.io/charts"
  chart      = "sonatype-nexus"
  version    = var.oteemo_sonatype_nexus_version

  namespace = "artifactory"
  name      = "sonatype-nexus"

  values = [
    file("./modules/artifactory/values/sonatype-nexus.yaml")
  ]


  wait = false

}