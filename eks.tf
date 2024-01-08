resource "aws_iam_role" "eks_cluster" {
  name = "eks_cluster"

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
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })


}


resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  #policy that we want to apply to the role
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  #role where policy should be applied
  role = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "eks" {
  name = "eks"

  role_arn = aws_iam_role.eks_cluster.arn

  version = "1.28"

  vpc_config {
    # should be true if we have bastion for access
    endpoint_private_access = false
    # if we don't have bastion and we are accessing cluster from our laptop this should be true
    endpoint_public_access = true

    subnet_ids = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id,
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
]

}

