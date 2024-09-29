resource "aws_codebuild_project" "project1" {
  # encryption_key         = "arn:aws:kms:us-west-2:770901818073:alias/aws/s3"
  name               = var.project_name
  description        = null
  project_visibility = "PRIVATE"
  build_timeout      = 60
  queued_timeout     = 480
  badge_enabled      = true
  # concurrent_build_limit = 1
  # resource_access_role   = null
  service_role   = aws_iam_role.project1_codebuild.arn
  source_version = "main"
  tags           = local.common_tags
  tags_all       = {}

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    location = null
    modes    = []
    type     = "NO_CACHE"
  }

  environment {
    # certificate                 = null
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    # privileged_mode             = false
    type = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      # group_name  = null
      status = "ENABLED"
      # stream_name = null
    }
    s3_logs {
      # bucket_owner_access = null
      # encryption_disabled = false
      # location            = null
      status = "DISABLED"
    }
  }

  source {
    # buildspec           = null
    git_clone_depth = 1
    # insecure_ssl        = false
    location = var.git_repo
    # report_build_status = true
    type = "GITHUB"
    git_submodules_config {
      fetch_submodules = true
    }
  }
}

resource "aws_iam_role" "project1_codebuild" {
  name        = "${var.project_name}-codebuild-service-role"
  description = null

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  # force_detach_policies = false
  # managed_policy_arns   = ["arn:aws:iam::770901818073:policy/service-role/CodeBuildBasePolicy-kithomak-cloud-project-1-codebuild-us-west-2"]
  # max_session_duration  = 3600

  # name_prefix           = null
  # path                  = "/service-role/"
  # permissions_boundary  = null
  tags     = local.common_tags
  tags_all = {}
}

data "aws_iam_policy_document" "project1_codebuild_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }

  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.website_bucket.arn,
      "${aws_s3_bucket.website_bucket.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "project1_codebuild_role_policy" {
  role   = aws_iam_role.project1_codebuild.name
  policy = data.aws_iam_policy_document.project1_codebuild_policy.json
}
