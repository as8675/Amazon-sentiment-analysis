# Output Elastic IP Address
output "acr_eip" {
    value = aws_eip.acr_eip.public_ip
}