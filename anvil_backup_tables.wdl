version 1.0

workflow anvil_backup_tables {
  input {
    String name
  }
  call backup_tables {
    input: name=name
  }
}


task backup_tables {
  input {
    String name
  }
  command {
    set -e
    Rscript /usr/local/anvil_backup_tables/anvil_backup_tables.R \
        --name ~{name}
  }
  output {
    # Write output to standard out
    File output_greeting = stdout()
  }
  runtime {
    # Pull from DockerHub
    docker: "amstilp/anvil-backup-tables-devel:latest"
  }
}
