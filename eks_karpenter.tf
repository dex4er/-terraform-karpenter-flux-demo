## AWS resources required by Karpenter

module "eks_karpenter" {
  ## https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/modules/karpenter
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "19.10.0"

  cluster_name = module.eks.cluster_name

  iam_role_use_name_prefix = false
  iam_role_name            = "${var.name}-karpenter"

  irsa_use_name_prefix = false
  irsa_name            = "${var.name}-irsa-karpenter"

  queue_name       = "${var.name}-karpenter"
  rule_name_prefix = "${substr(var.name, 0, 16)}-"

  irsa_oidc_provider_arn          = module.eks.oidc_provider_arn
  irsa_namespace_service_accounts = ["karpenter:karpenter"]

  create_iam_role = false
  iam_role_arn    = module.iam_role_node_group.iam_role_arn

  tags = {
    Cluster = var.name
    Object  = "module.eks_karpenter"
  }
}
