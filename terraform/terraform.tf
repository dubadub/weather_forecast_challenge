terraform {
  backend "s3" {
    bucket = "tf-state"
    key    = "weather/main.tfstate"
    region = "us-west-1"
    endpoint = "https://ams3.digitaloceanspaces.com"
    skip_credentials_validation = true
    skip_get_ec2_platforms = true
    skip_requesting_account_id = true
    skip_metadata_api_check = true
    acl = "private"
  }
}

