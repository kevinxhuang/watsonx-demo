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
  default     = "ibm-ubuntu-22-04-3-minimal-amd64-2"
}

variable "vpc_vsi_profile_name" {
  description = "VPC VSI profile name"
  type        = string
  default     = "gx3-16x80x1l4"
}

variable "jupyter_lab_image" {
  description = "Jupyter Lab container image"
  type        = string
  default     = "quay.io/jupyter/pytorch-notebook:cuda12-latest"
}

variable "gpu_count" {
  description = "GPU counnt for Jupyter Lab container"
  type        = string
  default     = "all"
}

variable "cpu_limit" {
  description = "CPU limit for Jupyter Lab container"
  type        = string
  default     = "6"
}

variable "memory_limit" {
  description = "Memory limit for Jupyter Lab container"
  type        = string
  default     = "24G"
}

