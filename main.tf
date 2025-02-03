provider  "aws" {
  #AWS_ACCESS_KEY = ''
  region = "ap-northeast-2"
}

resource  "aws_instance"  "example" {
  ami		= "ami-0f3a440bbcff3d043"
  instance_type = "t2.micro"
}
