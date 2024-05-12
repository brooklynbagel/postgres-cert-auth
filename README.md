### Connecting using an SSL cert

```sh
cd ssl
./gen-certs
psql 'host=localhost port=5432 user=testuser dbname=testdb sslcert=testuser.crt sslkey=testuser.key sslrootcert=root.crt sslmode=verify-full
```
