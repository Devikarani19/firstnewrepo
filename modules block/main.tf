module "first-module" {
    source = "../module practice"
    ami_id = "ami-0cc9838aa7ab1dce7"
    instance_type = "t2.micro"
    key_name = "newkeypair"
  }