# --- compute/main.tf ---

data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["2367896094514"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "random_id" "my_node_id" {
  byte_length = 2
  count       = var.instance_count
}

resource "aws_instance" "my_node" {
  count                  = var.instance_count # 1
  instance_type          = var.instance_type  # t3.micro
  ami                    = data.aws_ami.server_ami.id
  key_name               = var.key_name
  vpc_security_group_ids = var.public_sg
  subnet_id              = var.public_subnets[count.index]
  root_block_device {
    volume_size = var.vol_size # 10
  }
  user_data = templatefile(var.user_data_path,
    {
      nodename    = "my-${random_id.my_node_id[count.index].dec}"
      db_endpoint = var.db_endpoint
      db_name     = var.db_name
      db_username = var.db_username
      db_password = var.db_password
    }
  )
  provisioner "local-exec" {
    command = templatefile("${path.root}/scp_script.tpl",
      {
        nodeip   = self.public_ip
        k3s_path = "${path.cwd}/../"
        nodename = self.tags.Name
      }
    )
  }
  tags = {
    Name = "my_node-${random_id.my_node_id[count.index].dec}"
  }
}

resource "aws_lb_target_group_attachment" "my_tg_attach" {
  count            = var.instance_count
  target_group_arn = var.lb_target_group_arn
  target_id        = aws_instance.my_node[count.index].id
  port             = var.tg_port
}