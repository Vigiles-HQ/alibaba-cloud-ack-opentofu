module "argocd" {
  source        = "../../../modules/argocd"
  chart_version = var.chart_version
  ha            = true
}
