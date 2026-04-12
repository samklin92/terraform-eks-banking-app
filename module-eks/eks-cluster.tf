data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.name
}

resource "aws_eks_cluster" "eks" {
  name     = "${var.environment}-${var.cluster_name}"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_public_access  = true
    endpoint_private_access = true
    public_access_cidrs     = var.allowed_cidr_blocks
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_secrets_key.arn
    }
    resources = ["secrets"]
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller_policy
  ]

  tags = {
    Name        = "${var.environment}-${var.cluster_name}"
    Environment = var.environment
  }
}

resource "aws_kms_key" "eks_secrets_key" {
  description             = "KMS key for EKS secrets encryption - ${var.environment}"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name        = "${var.environment}-eks-secrets-kms-key"
    Environment = var.environment
  }
}

resource "aws_kms_alias" "eks_secrets_key_alias" {
  name          = "alias/${var.environment}-eks-secrets-key"
  target_key_id = aws_kms_key.eks_secrets_key.key_id
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks.id
  node_group_name = "${var.environment}-eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.private_subnet_ids
  version         = var.eks_version
  capacity_type   = var.capacity_type
  ami_type        = var.ami_type

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = var.instance_types

  labels = {
    role        = var.label_one
    environment = var.environment
  }

  tags = {
    Name        = "${var.environment}-eks-node-group"
    Environment = var.environment
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_policy,
    aws_iam_role_policy_attachment.ssm_managed_instance_core_policy
  ]
}

resource "time_sleep" "wait_for_eks" {
  create_duration = "30s"
  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.eks_node_group
  ]
}
