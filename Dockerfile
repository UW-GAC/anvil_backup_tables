FROM uwgac/anvildatamodels:0.4.1

RUN cd /usr/local && \
    git clone https://github.com/UW-GAC/anvil_backup_tables.git
