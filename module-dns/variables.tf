variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the hosted zone"
  type        = string
}

variable "nginx_lb_hostname" {
  description = "Nginx ingress load balancer hostname from EKS"
  type        = string
}
