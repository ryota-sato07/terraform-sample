variable "example_instance_type" {
  default = "t3.micro"
}

resource "aws_instance" "sample" {
  ami           = "ami-0c3fd0f5d33134a76"
  instance_type = var.example_instance_type
}

output "example_instance_id" {
  value = aws_instance.sample.id
}