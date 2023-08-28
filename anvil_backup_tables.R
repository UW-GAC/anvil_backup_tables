library(argparser)
library(tidyverse)

argp <- argparser("anvil_backup_tables") %>%
    add_argument("--name", help="Name to say hello to")

sprintf("Hello world!")
