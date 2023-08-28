version 1.0

workflow anvil_backup_tables {
  input {
    String name
  }
  call backup_tables { input: name=name }
}


task backup_tables {
  input {
    String name
  }
  command {
    echo "Hello ${name}!"
  }
  output {
    # Write output to standard out
    File output_greeting = stdout()
  }
  runtime {
    # Pull from DockerHub
    docker: "bioconductor/bioconductor_docker:latest"
  }
}
