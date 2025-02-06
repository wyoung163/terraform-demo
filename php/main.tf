provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "php-example" {
  ami		= "ami-086cfc2dbf7a20989"
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.php-example-sg.id]
  user_data             = <<-EOF
                        #!/bin/bash
                        systemctl start httpd
                        git clone https://github.com/uvelyster/cloud-demo.git
                        cd cloud-demo
                        cp *.php /var/www/html/
			EOF
  user_data_replace_on_change =	true
  key_name		= "test-vm-key"
}

resource "aws_security_group" "php-example-sg" {
  name	= "php-example"
  ingress {
	from_port = 80
	to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
  }
  
  egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_db_instance" "php-db" {
  allocated_storage    = 10
  db_name              = "webtest"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = ""
  password             = ""
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.php-db-sg.id]
  skip_final_snapshot  = true
}

resource "aws_security_group" "php-db-sg" {
  name = "php-db"
  ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
  }
}
