terraform {
  backend "s3" {
    bucket         = "seamless-sre-remote-state-s3"
    key            = "seamless-alb-path-target-group.tfstate"
    region         = "us-east-1"
    encrypt        = "true"
    dynamodb_table = "seamless-sre-remote-state-dynamodb"
  }
}
