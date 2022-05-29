# vaultwarden

* [dani-garcia/vaultwarden: Unofficial Bitwarden compatible server written in Rust, formerly known as bitwarden_rs (github.com)](https://github.com/dani-garcia/vaultwarden)
* Images for VaultWarden:  [vaultwarden/server Tags | Docker Hub](https://hub.docker.com/r/vaultwarden/server/tags)


## Todo

* [ ] Mounting `/data` from Azure Storage (see [link to ContainerApp docs](https://docs.microsoft.com/en-us/azure/container-apps/storage-mounts?pivots=aca-cli#configuration-1))
  * mounting storage from Azure Blobstorage creates the following problem on startup:\

* [ ] disable creation of new user accounts
* [ ] enable health checks
* [ ] Import existing passwords
* [ ] enable browser plugins
* [ ] enable backup of sqlite db in `/data`

## Update containerapp in Azure (manually)

```ps1
az containerapp update --name managedEnvironment-VaultWarden-9bfb --resource-group VaultWarden \
    --yaml app.yaml
```

## Building the custom container image

```sh
cd ./vaultwarden_cust
docker build -t vaultwarden/server_mp:1.25.0-alpine .
```

### Running the container

```sh
docker run --name vaultwarden -v /vw-data/:/data_back/ -p 8080:80 vaultwarden/server_mp:1.25.0-alpine
```


## Revision Log

### [27-05-22] Disable locking SQLite db
* mounting storage location from Azure Storage (CIFS) does not allow locking the db
* see [link to github discussion](https://github.com/dani-garcia/vaultwarden/issues/1201#issuecomment-716804769)
* Error: `[2022-05-26 09:55:13.850][panic][ERROR] thread 'main' panicked at 'Failed to turn on WAL: DatabaseError(__Unknown, "database is locked")': src/db/mod.rs:445`
