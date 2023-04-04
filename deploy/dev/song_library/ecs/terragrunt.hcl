include "root" {
    path = find_in_parent_folders()
}

terraform {
    source = "${get_parent_terragrunt_dir("root")}/../terraform-modules/ecs"
}

inputs = {
    aws_region = "us-west-2"

    container_definitions = jsonencode([
        {
            name = var.task_name 
            image = var.image
            cpu = 256 
            memory = 512 
            essential = true 
            environment = [
                {
                    name = "MONGODB_URL"
                    value = local.docdb_conn_string
                }
            ]
        }
    ])
}