terraform {
  backend "s3" {
    bucket  = "asmaa00"
    key     = "depi.tfstate"
    region  = "us-east-1"
    profile = "terraform"
    
  }
}