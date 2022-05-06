###############
## Variables ##
###############
variable "aws_region" {
  default = "ap-northeast-1"
}

variable "company-name" {
  default = "Company"
} 

variable "users" {
  type = list(string)
  default = [
    "user1@example.com",
    "user2@example.com",
    "user3@example.com"
  ]
}