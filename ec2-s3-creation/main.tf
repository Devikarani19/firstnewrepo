resource "aws_instance" "Devi" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  tags = {
    Name = "newec2"
  }
}
resource "aws_s3_bucket" "name" { 
    bucket = "abcddev"
   
}
