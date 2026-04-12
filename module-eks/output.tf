output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.eks.name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.eks.endpoint
  sensitive   = true
}

output "cluster_certificate_authority_data" {
  description = "EKS cluster certificate authority data"
  value       = aws_eks_cluster.eks.certificate_authority[0].data
  sensitive   = true
}

output "nginx_ingress_load_balancer_hostname" {
  description = "Nginx ingress load balancer hostname"
  value       = data.aws_lb.nginx_ingress.dns_name
}

output "nginx_ingress_lb_dns" {
  description = "Nginx ingress load balancer DNS name"
  value       = data.aws_lb.nginx_ingress.dns_name
}

output "ecr_backend_url" {
  description = "ECR repository URL for backend"
  value       = aws_ecr_repository.bank_backend.repository_url
  sensitive   = true
}

output "ecr_frontend_url" {
  description = "ECR repository URL for frontend"
  value       = aws_ecr_repository.bank_frontend.repository_url
  sensitive   = true
}
