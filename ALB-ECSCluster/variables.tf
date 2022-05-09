###############
## Variables ##
###############
variable "aws_region" {
  default = "ap-northeast-1"
}

variable "system-name" {
  default = "company01"
}

variable "http-port" {
  default = 80
}

variable "test-http-port" {
  default = 10080
}

variable "management-subnets-cidr" {
  type = list(string)
  default = [ 
    "10.0.253.0/24",
    "10.0.254.0/24",
    "10.0.255.0/24"
  ]
  
}