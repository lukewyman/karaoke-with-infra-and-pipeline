output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}

output "public_subnets_ids" {
  value = data.terraform_remote_state.vpc.outputs.public_subnets_ids
}

output "public_subnets_cidr_blocks" {
  value = data.terraform_remote_state.vpc.outputs.public_subnets_cidr_blocks
}

output "app_subnets_ids" {
  value = data.terraform_remote_state.vpc.outputs.app_subnets_ids
}

output "app_subnets_cidr_blocks" {
  value = data.terraform_remote_state.vpc.outputs.app_subnets_cidr_blocks
}

output "db_subnets_ids" {
  value = data.terraform_remote_state.vpc.outputs.db_subnets_ids
}

output "docdb_endpoint" {
  value = data.terraform_remote_state.docdb.outputs.docdb_endpoint
}

output "docdb_username_arn" {
  value = data.terraform_remote_state.docdb.outputs.docdb_username_arn
}

output "docdb_password_arn" {
  value = data.terraform_remote_state.docdb.outputs.docdb_password_arn
}

output "docdb_port" {
  value = data.terraform_remote_state.docdb.outputs.docdb_port
}