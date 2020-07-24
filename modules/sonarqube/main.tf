resource "helm_release" "sonarqube" {

  repository = "https://oteemo.github.io/charts"
  chart      = "sonarqube"
  version    = var.sonarqube_version

  namespace = "artifactory"
  name      = "sonarqube"

  values = [
    file("./modules/sonarqube/values/sonarqube.yaml")
  ]

  wait = false

}