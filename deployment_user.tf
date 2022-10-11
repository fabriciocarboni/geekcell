
locals {
  repositories_arn = aws_ecr_repository.ecr_repo.arn
}

resource "aws_iam_user" "deployment-user" {
  name = "app-deployer"
  path = "/system/"
}

resource "aws_iam_access_key" "deployment-user" {
  user = aws_iam_user.deployment-user.name
}

resource "aws_iam_user_policy" "deployment-user" {
  user   = aws_iam_user.deployment-user.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:PutLifecyclePolicy",
                "ecr:PutImageTagMutability",
                "ecr:DescribeImageScanFindings",
                "ecr:StartImageScan",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:GetDownloadUrlForLayer",
                "ecr:ListTagsForResource",
                "ecr:UploadLayerPart",
                "ecr:ListImages",
                "ecr:PutImage",
                "ecr:UntagResource",
                "ecr:BatchGetImage",
                "ecr:DescribeImages",
                "ecr:TagResource",
                "ecr:DescribeRepositories",
                "ecr:StartLifecyclePolicyPreview",
                "ecr:InitiateLayerUpload",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetRepositoryPolicy",
                "ecr:GetLifecyclePolicy",
                "ecr:GetAuthorizationToken",
                "ecr:CompleteLayerUpload"
            ],
            "Resource": [ "${local.repositories_arn}" ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability"
            ],
            "Resource": [ "*" ]
        }
    ]
}
EOF
}