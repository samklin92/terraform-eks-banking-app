data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks.name
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.12.0"
  namespace        = "ingress-nginx"
  create_namespace = true
  values           = [file("${path.module}/nginx-ingress-values.yaml")]
  force_update     = true
  replace          = true
  cleanup_on_fail  = true

  depends_on = [
    aws_eks_node_group.eks_node_group,
    time_sleep.wait_for_eks
  ]
}

data "aws_lb" "nginx_ingress" {
  tags = {
    "kubernetes.io/service-name" = "ingress-nginx/nginx-ingress-ingress-nginx-controller"
  }
  depends_on = [helm_release.nginx_ingress]
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "1.14.5"
  namespace        = "cert-manager"
  create_namespace = true
  force_update     = true
  replace          = true
  cleanup_on_fail  = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [
    helm_release.nginx_ingress,
    time_sleep.wait_for_eks
  ]
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.7.11"
  namespace        = "argocd"
  create_namespace = true
  values           = [file("${path.module}/argocd-values.yaml")]
  force_update     = true
  replace          = true
  cleanup_on_fail  = true

  depends_on = [
    helm_release.nginx_ingress,
    helm_release.cert_manager,
    time_sleep.wait_for_eks
  ]
}