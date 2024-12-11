#create ec2 server

resource "aws_instance" "server1" {
    instance_type = "t2.micro"
    ami = "ami-0166fe664262f664c"
    key_name = aws_key_pair.key.key_name
    security_groups = [ aws_security_group.sg.name]
    user_data = file("userdata.sh")
    tags = {
      Name = "Terraform EC2"
    }
}
#create ebs volume

resource "aws_ebs_volume" "vol1" {
  availability_zone = aws_instance.server1.availability_zone
  size = 20
  tags = {
    Name = "devvolume"
    Team = "cloud"
  }
}
#attach volume
resource "aws_volume_attachment" "name" {
  device_name = "/dev/sdb"
  volume_id = aws_ebs_volume.vol1.id
  instance_id = aws_instance.server1.id
}

# Key pair
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits = 2048
}
resource "aws_key_pair" "key" {
  key_name = "utc-key"
  public_key = tls_private_key.tls.public_key_openssh
}

resource "local_file" "key1" {
  filename = "utc-key.pem"
  content = tls_private_key.tls.private_key_pem
}

#Security group

resource "aws_security_group" "sg" {
  name = "webserver-sg"
  description = "allow 22 and 80"
  ingress {
    description = "allow 22 80"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
     description = "allow 80"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
     description = "allow 8080"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}