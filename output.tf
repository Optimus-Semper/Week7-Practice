output "public-ip" {
 value = aws_instance.server1.public_ip
}
output "ssh-command" {
  value = "ssh -i ${local_file.key1.filename}  ec2-user@${aws_instance.server1.public_ip}"
}
output "volume_id" {
  value = aws_ebs_volume.vol1.id
}