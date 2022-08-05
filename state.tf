terraform{
    backend "s3" {
        bucket = "matto-cicd-pipeline-second"
        encrypt = true
        key = "terraform-tfstate"
        region = "eu-central-1"
    }
}

provider "aws" {
    region = "eu-central-1"
}