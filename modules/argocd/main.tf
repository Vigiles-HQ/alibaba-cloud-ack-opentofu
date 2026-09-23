resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version
  timeout          = 600

  values = [
    yamlencode({
      global = {
        nodeSelector = {
          "node-role" = "system"
        }
        tolerations = [
          {
            key      = "node-role"
            operator = "Equal"
            value    = "system"
            effect   = "NoSchedule"
          }
        ]
      }
      redis-ha = {
        enabled = var.ha
      }
      controller = {
        replicas = 1
      }
      server = {
        replicas = local.server_replicas
        service = {
          type = "ClusterIP"
        }
      }
      repoServer = {
        replicas = local.repo_replicas
      }
      applicationSet = {
        replicas = local.server_replicas
      }
      configs = {
        params = {
          "server.insecure" = false
        }
      }
    })
  ]

}
