resource "aws_iam_role" "nodes_general" {
  name = "eks-node-group-general"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })


}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_general" {
  #policy that we want to apply to the role
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  #role where policy should be applied
  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general" {
  #policy that we want to apply to the role
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  #role where policy should be applied
  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_ready_only" {
  #policy that we want to apply to the role
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  #role where policy should be applied
  role = aws_iam_role.nodes_general.name
}

# creating worker node group for eks cluster
resource "aws_eks_node_group" "nodes_general" {
  cluster_name = aws_eks_cluster.eks.name

  node_group_name = "nodes_general"

  node_role_arn = aws_iam_role.nodes_general.arn
  # adding only private subnets for worker nodes since only load balancer will have public IP 
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
  # this should be replaced by autoscaler probably 
  scaling_config {
    desired_size = 1

    max_size = 1

    min_size = 1
  }

  ami_type = "AL2_x86_64"

  capacity_type = "ON_DEMAND"

  disk_size = 20

  force_update_version = false

  instance_types = ["t3.small"]

  labels = {
    role = "nodes-general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_ready_only
  ]
}