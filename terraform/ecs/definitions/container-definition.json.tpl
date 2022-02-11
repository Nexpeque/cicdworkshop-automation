[
    {
        "name": "${name}",
        "image": "${image}",
        "cpu": 10,
        "memory": 256,
        "essential": true,
        "portMappings": [
            {
                "containerPort": ${container_port}
            }
        ]
    }
]