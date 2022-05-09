locals {
  api-server-name = "api-${var.system-name}"
}
locals {
  backend-alb-name = "backend-alb-${var.system-name}"
}
locals {
  backend-alb-sg-name = "sg-backend-alb-${var.system-name}"
}
locals {
  backend-alb-tg-name = "tg-backend-alb-${var.system-name}"
}
