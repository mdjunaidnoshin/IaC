terraform {
  backend "s3" {
    bucket = "terraform-aws-resources-s3"
    key    = "path_relative_to_include()/terraform.tfstate"
    use_lockfile = true
    region = "ap-south-1"
    encrypt = true
  }
}