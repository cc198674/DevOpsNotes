provider "aws" {
  region                  = "ap-southeast-2"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                 = "default"
}
