output "instance_ids" {
  value = [
    for x in aws_instance.instance :
    [
      "Server Name = ${x.tags["Name"]}",
      "ID = ${x.id}",
      "Public IP = ${x.public_ip}",
      "Private IP = ${x.private_ip}",
    ]
  ]
}

/*output "security_group_outbound_rules" {
  #  value = aws_security_group.main_sg.ingress[*].cidr_blocks
  value = [
    for x in aws_security_group.main_sg.ingress :
    [
      "Cidr_block = ${x.cidr_blocks[0]}",
      "Protocol = ${x.protocol}",
      "From_port = ${x.from_port}",
      "To_port = ${x.to_port}",
    ]
  ]
}*/
