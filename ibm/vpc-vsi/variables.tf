variable "resource_group" {
  description = "The name of the Resource Group"
  type        = string
  default     = "Default"
}

variable "region" {
  description = "The name of the region"
  type        = string
  default     = "ca-tor"
}

variable "zone" {
  description = "The name of the avalability zone"
  type        = string
  default     = "ca-tor-1"
}

variable "vpc" {
  description = "The name of the VPC"
  type        = string
}

variable "classic_access" {
  description = "Enable VPC access to classic infrastructure"
  type        = bool
  default     = false
}

variable "keys" {
  description = "The list of VPC SSH Key names"
  type        = list(string)
}

variable "tags" {
  description = "The tags for the resources"
  type        = list(string)
  default     = []
}

variable "vpc_vsi_image_name" {
  description = "VPC VSI image name"
  type        = string
  default     = "ibm-ubuntu-20-04-6-minimal-amd64-1"
}

variable "vpc_vsi_profile_name" {
  description = "VPC VSI profile name"
  type        = string
  default     = "bx2-2x8"
}
