module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_version = "1.20"
  cluster_name    = local.cluster_name
  subnets         = module.vpc.private_subnets

  tags = {
    Environment = "speech2text"
    GithubRepo  = "speech2text"
    GithubOrg   = "efuquen"
  }

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "worker-group"
      instance_type                 = "t2.small"
      additional_security_group_ids = [aws_security_group.worker_mgmt.id]
      asg_desired_capacity          = 1
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}