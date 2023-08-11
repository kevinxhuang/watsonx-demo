output "public_ip" {
  description = "Public IP"
  value       = ibm_is_floating_ip.vsi-fip.address
}
