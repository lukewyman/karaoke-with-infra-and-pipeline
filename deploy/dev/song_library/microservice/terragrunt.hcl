include {
    path = find_in_parent_folders() 
}

terraform {
    source = "${get_parent_terragrunt_dir("root")}/../../infrastructure/microservice"
}

dependency "lookup" {
    config_path = "../../lookup"
}

dependency "ecr" {
    config_path = "../ecr"
}

dependency "ecs" {
    config_path = "../../ecs"
}

dependency "lb" {
    config_path = "../../lb"
}

inputs = {
    app_prefix = "karaoke-app-song-lib-"
    app_subnets_ids = dependency.lookup.outputs.app_subnets_ids
    aws_region = "us-west-2"
    cluster_name = dependency.ecs.outputs.cluster_name
    container_definition = {
      name = "song-lib"
      image = dependency.ecr.outputs.image_uri
      container_port = 8081
      host_port = 8081
      environment = {
        "DOCDB_ENDPOINT" = dependency.lookup.outputs.docdb_endpoint
        "DOCDB_PORT" = dependency.lookup.outputs.docdb_port

      }
      secrets = {
        "DOCDB_USERNAME" = dependency.lookup.outputs.docdb_username_arn
        "DOCDB_PASSWORD" = dependency.lookup.outputs.docdb_password_arn
      }
    }
    docdb_password_arn = dependency.lookup.outputs.docdb_password_arn
    docdb_username_arn = dependency.lookup.outputs.docdb_username_arn
    ecs_security_group_id = dependency.ecs.outputs.security_group_id
    lb_listener_arn = dependency.lb.outputs.lb_listener_arn
    priority = 10
    service_name = "song-lib"
    vpc_id = dependency.lookup.outputs.vpc_id
}
