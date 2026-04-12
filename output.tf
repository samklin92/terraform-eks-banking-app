output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks-deployment.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks-deployment.cluster_endpoint
  sensitive   = true
}

output "eks_cluster_certificate_authority" {
  description = "EKS cluster certificate authority"
  value       = module.eks-deployment.cluster_certificate_authority_data
  sensitive   = true
}

output "nginx_lb_hostname" {
  description = "Nginx ingress load balancer hostname"
  value       = module.eks-deployment.nginx_ingress_load_balancer_hostname
}

output "route53_name_servers" {
  description = "Route53 nameservers - paste into Namecheap custom DNS"
  value       = module.route53-deployment.route53_name_servers
}

output "ecr_backend_url" {
  description = "ECR backend repository URL"
  value       = module.eks-deployment.ecr_backend_url
  sensitive   = true
}

output "ecr_frontend_url" {
  description = "ECR frontend repository URL"
  value       = module.eks-deployment.ecr_frontend_url
  sensitive   = true
}
