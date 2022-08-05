// Pipeline comment 2
resource "aws_codebuild_project" "tf-plan" {
  name          = "tf-cicd-plan2"
  description   = "Pplan stage for terraform"
  service_role  = aws_iam_role.tf-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:1.2.6"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential {
      credential = var.dockerhub_credentials
      credential_provider = "SECRETS_MANAGER"
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = file("buildspec/plan-buildspec.yml")
  }
}

resource "aws_codebuild_project" "tf-apply" {
  name          = "tf-cicd-apply2"
  description   = "Apply stage for terraform"
  service_role  = aws_iam_role.tf-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:0.14.3"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type = "CODEPIPELINE"
    buildspec = file("buildspec/apply-buildspec.yml")
  }
}

resource "aws_codepipeline" "cicd_pipeline" {
    name = "tf-cicd2"
    role_arn = aws_iam_role.tf-code-pipeline-role.arn

    artifact_store {
        location = aws_s3_bucket.codepipeline_artefacts.id
        type     = "S3"
    }

    stage {
        name = "Source"
        action {
            name = "Source"
            category = "Source"
            owner = "AWS"
            provider = "CodeStarSourceConnection"
            version = "1"
            output_artifacts = [ "tf-code2" ]
            configuration = {
                FullRepositoryId  = "TheRealTechStacker/aws-cicd-pipeline-second"
                BranchName = "main"
                ConnectionArn = var.codestar_connector_credentials
                OutputArtifactFormat = "CODE_ZIP"
            }
        }
    }

    stage {
        name = "Plan"
        action {
            name = "Build"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = [ "tf-code2" ]
            configuration = {
              ProjectName = "tf-cicd-plan"
            }
        }
    }

    stage {
        name = "Deploy"
        action {
            name = "Deploy"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = [ "tf-code2" ]
            configuration = {
              ProjectName = "tf-cicd-plan"
            }
        }
    }
}