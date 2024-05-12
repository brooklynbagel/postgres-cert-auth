#!/bin/bash
set -e

cp /tmp/server.crt /tmp/server.key /tmp/root.crt "${PGDATA}"
chown postgres:postgres "${PGDATA}/server.crt" "${PGDATA}/server.key" "${PGDATA}/root.crt"
chmod 600 "${PGDATA}/server.key"
chmod 644 "${PGDATA}/server.crt"

cat <<EOF | tee -a "${PGDATA}/postgresql.conf"
ssl = on
ssl_ca_file = 'root.crt'
ssl_cert_file = 'server.crt'
ssl_key_file = 'server.key'
EOF

# force ssl for remote connections
sed -i 's/host all all all .*/hostssl all all all cert clientcert=verify-full/' "${PGDATA}/pg_hba.conf"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -c "select pg_reload_conf()"
