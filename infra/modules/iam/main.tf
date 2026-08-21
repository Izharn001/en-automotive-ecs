data "aws_caller_identity" "current" {}

resource "aws_iam_role" "this" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

}

resource "aws_iam_role" "github_actions" {
  name = "${var.iam_role_name}-github-actions"

  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_policy.json

  tags = var.tags
}

data "aws_iam_policy_document" "github_actions_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:Izharn001@212381275/en-automotive-ecs@1306515144:*"
      ]
    }
  }
}

data "aws_iam_policy_document" "github_actions_core" {
  statement {
    sid    = "ManageECS"
    effect = "Allow"

    actions = [
      "ecs:CreateCluster",
      "ecs:DeleteCluster",
      "ecs:DescribeClusters",
      "ecs:TagResource",

      "ecs:CreateService",
      "ecs:UpdateService",
      "ecs:DeleteService",
      "ecs:DescribeServices",

      "ecs:RegisterTaskDefinition",
      "ecs:DeregisterTaskDefinition",
      "ecs:DescribeTaskDefinition",

      "ecs:ListTaskDefinitions",
      "ecs:ListTasks",
      "ecs:DescribeTasks"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ManageECR"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:CreateRepository",
      "ecr:DeleteRepository",
      "ecr:DescribeRepositories",
      "ecr:ListTagsForResource",
      "ecr:TagResource",
      "ecr:UntagResource",
      "ecr:PutLifecyclePolicy",
      "ecr:GetLifecyclePolicy",
      "ecr:DeleteLifecyclePolicy",
      "ecr:PutImageScanningConfiguration",
      "ecr:PutImageTagMutability"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ManageCloudWatchLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:DeleteLogGroup",
      "logs:DescribeLogGroups",
      "logs:PutRetentionPolicy",
      "logs:DeleteRetentionPolicy",
      "logs:AssociateKmsKey",
      "logs:DisassociateKmsKey",
      "logs:ListTagsForResource",
      "logs:TagResource",
      "logs:UntagResource"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ManageELB"
    effect = "Allow"

    actions = [
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",

      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:ModifyTargetGroup",

      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:ModifyListener",

      "elasticloadbalancing:DescribeTargetHealth",

      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:DescribeTags"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "github_actions_network" {
  statement {
    sid    = "ManageNetwork"
    effect = "Allow"

    actions = [
      "ec2:DescribeVpcs",
      "ec2:CreateVpc",
      "ec2:DeleteVpc",
      "ec2:ModifyVpcAttribute",

      "ec2:DescribeSubnets",
      "ec2:CreateSubnet",
      "ec2:DeleteSubnet",
      "ec2:ModifySubnetAttribute",

      "ec2:DescribeInternetGateways",
      "ec2:CreateInternetGateway",
      "ec2:AttachInternetGateway",
      "ec2:DetachInternetGateway",
      "ec2:DeleteInternetGateway",

      "ec2:DescribeRouteTables",
      "ec2:CreateRouteTable",
      "ec2:DeleteRouteTable",
      "ec2:AssociateRouteTable",
      "ec2:DisassociateRouteTable",
      "ec2:CreateRoute",
      "ec2:DeleteRoute",

      "ec2:DescribeAddresses",
      "ec2:AllocateAddress",
      "ec2:ReleaseAddress",

      "ec2:DescribeNatGateways",
      "ec2:CreateNatGateway",
      "ec2:DeleteNatGateway",

      "ec2:DescribeSecurityGroups",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupEgress",

      "ec2:CreateTags",
      "ec2:DeleteTags"
    ]

    resources = ["*"]
  }

}

data "aws_iam_policy_document" "github_actions_security" {
  statement {
    sid    = "ManageProjectRoles"
    effect = "Allow"

    actions = [
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:DeleteRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy"
    ]

    resources = [
      aws_iam_role.this.arn,
      aws_iam_role.github_actions.arn
    ]
  }

  statement {
    sid    = "ManageProjectPolicy"
    effect = "Allow"

    actions = [
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:CreatePolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:DeletePolicy",
      "iam:TagPolicy",
      "iam:UntagPolicy"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.iam_role_name}-github-actions-core",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.iam_role_name}-github-actions-network",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.iam_role_name}-github-actions-security",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.iam_role_name}-github-actions-storage"
    ]
  }

  statement {
    sid    = "CreateProjectRoles"
    effect = "Allow"

    actions = [
      "iam:CreateRole"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.iam_role_name}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.iam_role_name}-github-actions"
    ]
  }


  statement {
    sid    = "CreateProjectPolicy"
    effect = "Allow"

    actions = [
      "iam:CreatePolicy"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.iam_role_name}-github-actions-core",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.iam_role_name}-github-actions-network",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.iam_role_name}-github-actions-security",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.iam_role_name}-github-actions-storage"
    ]
  }

  statement {
    sid    = "ManageGitHubOIDCProvider"
    effect = "Allow"

    actions = [
      "iam:GetOpenIDConnectProvider",
      "iam:DeleteOpenIDConnectProvider",
      "iam:UpdateOpenIDConnectProviderThumbprint",
      "iam:AddClientIDToOpenIDConnectProvider",
      "iam:RemoveClientIDFromOpenIDConnectProvider",
      "iam:TagOpenIDConnectProvider",
      "iam:UntagOpenIDConnectProvider"
    ]

    resources = [
      aws_iam_openid_connect_provider.github.arn
    ]
  }


  statement {
    sid    = "CreateGitHubOIDCProvider"
    effect = "Allow"

    actions = [
      "iam:CreateOpenIDConnectProvider"
    ]

    resources = ["*"]
  }




  statement {
    sid    = "PassECSTaskExecutionRole"
    effect = "Allow"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      aws_iam_role.this.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"

      values = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }


  statement {
    sid    = "ManageACM"
    effect = "Allow"

    actions = [
      "acm:DescribeCertificate",
      "acm:ListTagsForCertificate",
      "acm:RequestCertificate",
      "acm:AddTagsToCertificate",
      "acm:DeleteCertificate"
    ]

    resources = ["*"]
  }


  statement {
    sid    = "ManageRoute53HostedZone"
    effect = "Allow"

    actions = [
      "route53:GetHostedZone",
      "route53:ListResourceRecordSets",
      "route53:ChangeResourceRecordSets",
      "route53:ListTagsForResource"
    ]

    resources = [
      "arn:aws:route53:::hostedzone/Z03318022M6754FRNIKCL"
    ]
  }

  statement {
    sid    = "ReadRoute53Changes"
    effect = "Allow"

    actions = [
      "route53:GetChange"
    ]

    resources = ["*"]
  }


  statement {
    sid    = "ManageProjectKMS"
    effect = "Allow"

    actions = [
      "kms:DescribeKey",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:ListResourceTags",
      "kms:EnableKeyRotation",
      "kms:DisableKeyRotation",
      "kms:PutKeyPolicy",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]

    resources = [
      "arn:aws:kms:eu-west-2:${data.aws_caller_identity.current.account_id}:key/*"
    ]
  }

}

data "aws_iam_policy_document" "github_actions_storage" {
  statement {
    sid    = "TerraformStateAccess"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketVersioning",
      "s3:GetBucketLocation"
    ]

    resources = [
      var.terraform_state_bucket_arn
    ]
  }

  statement {
    sid    = "TerraformStateObjectAccess"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${var.terraform_state_bucket_arn}/*"
    ]
  }



  statement {
    sid    = "ManageALBLogBucket"
    effect = "Allow"

    actions = [
      "s3:GetBucketPolicy",
      "s3:PutBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:GetBucketPublicAccessBlock",
      "s3:PutBucketPublicAccessBlock",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:GetBucketTagging",
      "s3:PutBucketTagging",
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::en-automotive-alb-logs-707305182979"
    ]
  }



}

resource "aws_iam_policy" "github_actions_core" {
  name   = "${var.iam_role_name}-github-actions-core"
  policy = data.aws_iam_policy_document.github_actions_core.json
}

resource "aws_iam_policy" "github_actions_network" {
  name   = "${var.iam_role_name}-github-actions-network"
  policy = data.aws_iam_policy_document.github_actions_network.json
}

resource "aws_iam_policy" "github_actions_security" {
  name   = "${var.iam_role_name}-github-actions-security"
  policy = data.aws_iam_policy_document.github_actions_security.json
}

resource "aws_iam_policy" "github_actions_storage" {
  name   = "${var.iam_role_name}-github-actions-storage"
  policy = data.aws_iam_policy_document.github_actions_storage.json
}

resource "aws_iam_role_policy_attachment" "github_actions_core" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_core.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_network" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_network.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_security" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_security.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_storage" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_storage.arn
}