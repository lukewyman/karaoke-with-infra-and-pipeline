output "vpc_id" {
    value = data.terraform_remote_state.vpc.outputs.vpc_id 
}

output "docdb_endpoint" {
    value = data.terraform_remote_state.docdb.outputs.docdb_endpoint
}
