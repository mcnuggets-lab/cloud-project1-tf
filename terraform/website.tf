locals {
  base_public_dir = "../public/"
}

module "template_files" {
  source = "hashicorp/dir/template"

  base_dir = local.base_public_dir
  template_vars = {
    # Pass in any values that you wish to use in your templates.
  }

  depends_on = [aws_cloudfront_distribution.distribution, local_file.hugo_config, local_file.buildspec_yml]
}

resource "aws_s3_object" "website_content" {
  for_each = module.template_files.files

  bucket       = aws_s3_bucket.website_bucket.id
  key          = each.key
  content_type = each.value.content_type
  source       = each.value.source_path
  content      = each.value.content

  etag       = each.value.digests.md5
  depends_on = [aws_cloudfront_distribution.distribution, local_file.hugo_config, local_file.buildspec_yml]
}

resource "local_file" "hugo_config" {
  content = templatefile("templates/config.toml.tpl", {
    cloudfront_url_endpoint = "https://${aws_cloudfront_distribution.distribution.domain_name}"
    bucket_id               = aws_s3_bucket.website_bucket.id
    aws_region              = var.aws_region
  })
  filename = "../config.toml"

  provisioner "local-exec" {
    command     = "cd ..; rm -r -force public; bin\\hugo"
    interpreter = ["PowerShell", "-Command"]
  }
}

resource "local_file" "buildspec_yml" {
  content = templatefile("templates/buildspec.yml.tpl", {
    bucket_id  = aws_s3_bucket.website_bucket.id
    aws_region = var.aws_region
  })
  filename = "../buildspec.yml"
}

resource "local_file" "readme" {
  content = templatefile("templates/README.md.tpl", {
    cloudfront_url_endpoint = "https://${aws_cloudfront_distribution.distribution.domain_name}"
    badge_url               = aws_codebuild_project.project1.badge_url
  })
  filename = "../README.md"
}
