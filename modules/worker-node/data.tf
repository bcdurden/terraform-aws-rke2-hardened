data "aws_lb" "apiserver_lb" {
  name  = var.apiserver_lb_name
}