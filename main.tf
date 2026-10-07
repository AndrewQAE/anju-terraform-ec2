resource "aws_instance" "anju_app" {
  ami                    = "ami-0e5df6fd7455a69b3"
  instance_type          = "t3.micro"
  key_name               = "anju-demo"
  vpc_security_group_ids = [aws_security_group.anju_app_sg.id]
  user_data              = filebase64("userdata.sh")
  tags = {
    Name = "anju-app"
  }




}
