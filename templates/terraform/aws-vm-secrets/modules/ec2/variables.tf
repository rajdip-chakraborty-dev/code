variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Name of the AWS key pair"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the instance will be launched"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "ec2_username" {
  description = "Username for the EC2 instance"
  type        = string
}

variable "ec2_password" {
  description = "Password for the EC2 instance"
  type        = string
  sensitive   = true
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to grant access to"
  type        = string
}

variable "use_ubuntu" {
  description = "Whether to use Ubuntu AMI (true) or Amazon Linux 2 (false)"
  type        = bool
  default     = false
}

variable "root_volume_type" {
  description = "Type of root volume"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "Size of root volume in GB"
  type        = number
  default     = 20
}

variable "common_tags" {
  description = "Common tags to apply to all EC2 resources"
  type        = map(string)
  default     = {}
}
