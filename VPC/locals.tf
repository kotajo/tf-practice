locals {
  vpc = {
    name = "vpc-${var.system-name}"
    cidr = "10.0.0.0/16"
  }
}

locals {
  public-subnet01 = {
    name = "${var.system-name}-public-subnet-01"
    cidr = "10.0.0.0/24"
    az = "ap-northeast-1a"
  }
}

locals {
  public-subnet02 = {
    name = "${var.system-name}-public-subnet02"
    cidr = "10.0.1.0/24"
    az = "ap-northeast-1c"
  }
}

locals {
  public-subnet03 = {
    name = "${var.system-name}-public-subnet03"
    cidr = "10.0.2.0/24"
    az = "ap-northeast-1d"
  }
}

locals {
  private-subnet01 = {
    name = "${var.system-name}-private-subnet01"
    cidr = "10.0.10.0/24"
    az = "ap-northeast-1a"
  }
}

locals {
  private-subnet02 = {
    name = "${var.system-name}-private-subnet02"
    cidr = "10.0.11.0/24"
    az = "ap-northeast-1c"
  }
}

locals {
  private-subnet03 = {
    name = "${var.system-name}-private-subnet03"
    cidr = "10.0.12.0/24"
    az = "ap-northeast-1d"
  }
}
locals {
  db-subnet01 = {
    name = "${var.system-name}-db-subnet01"
    cidr = "10.0.20.0/24"
    az = "ap-northeast-1a"
  }
}

locals {
  db-subnet02 = {
    name = "${var.system-name}-db-subnet02"
    cidr = "10.0.21.0/24"
    az = "ap-northeast-1c"
  }
}

locals {
  db-subnet03 = {
    name = "${var.system-name}-db-subnet03"
    cidr = "10.0.22.0/24"
    az = "ap-northeast-1d"
  }
}

locals {
  maintenance-subnet01 = {
    name = "${var.system-name}-maintenance-subnet-01"
    cidr = "10.0.253.0/24"
    az = "ap-northeast-1a"
  }
}

locals {
  maintenance-subnet02 = {
    name = "${var.system-name}-maintenance-subnet02"
    cidr = "10.0.254.0/24"
    az = "ap-northeast-1c"
  }
}

locals {
  maintenance-subnet03 = {
    name = "${var.system-name}-maintenance-subnet03"
    cidr = "10.0.255.0/24"
    az = "ap-northeast-1d"
  }
}