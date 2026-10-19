resource "aws_instance" "anju_app" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.anju_app_sg.id]
  user_data              = filebase64("userdata.sh")
  tags = {
    Name = "anju-app-${var.environment}"
  }




}
