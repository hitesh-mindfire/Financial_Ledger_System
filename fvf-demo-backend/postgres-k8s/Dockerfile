FROM postgres:15

ENV POSTGRES_DB=Financial_ledger_db
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=123456

# Copy backup.sql to /docker-entrypoint-initdb.d/ directory
COPY ./backup.sql /docker-entrypoint-initdb.d/backup.sql

EXPOSE 5432