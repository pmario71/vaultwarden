# vaultwarden

* [dani-garcia/vaultwarden: Unofficial Bitwarden compatible server written in Rust, formerly known as bitwarden_rs (github.com)](https://github.com/dani-garcia/vaultwarden)
* alpine-based Images for VaultWarden:  [vaultwarden/server Tags | Docker Hub](https://hub.docker.com/r/vaultwarden/server/tags?name=alpine)


## Todo

* [x] Mounting `/data` from Azure Storage (see [link to ContainerApp docs](https://docs.microsoft.com/en-us/azure/container-apps/storage-mounts?pivots=aca-cli#configuration-1))
  * mounting `/data` from Azure Blobstorage directly does not work (SQLite fails to lock files)

* [x] disable creation of new user accounts
* [ ] enable health checks
* [ ] Import existing passwords
* [ ] enable browser plugins
* [x] enable backup of sqlite db in `/data`

## 15.11.2024 - Config Storage

following settings are overwritten:

```ps1
# disable 'write-ahead-lock'
ENABLE_DB_WAL=false

# data folder is overwritten
DATA_FOLDER=data_mapped
```

* [Running `vaultwarden` without WAL enabled](https://github.com/dani-garcia/vaultwarden/wiki/Running-without-WAL-enabled)

## 11.11.2024 - Updated to latest Vaultwarden Version

* docker tag is not passed into `dockerfile`
* customizing that "copies db into container before startup" removed
  * according to article, db file only needs to be precreated <https://blog.mwiedemeyer.de/post/2023/Vaultwarden-Bitwarden-on-Azure-Container-Apps/>

## Create role-binding to authenticate against Azure

```sh
az ad sp create-for-rbac --name "ghActionVaultwarden" --scope /subscriptions/3bd4723e-ab5f-41bd-90c1-0e8b8a944536/resourceGroups/VaultWarden --role Contributor --json-auth
```

* json output is then configured in Github Secrets for:  `VAULTWARDEN_AZURE_CREDENTIALS`

## Backup of vault

link in storage explorer to blob storage:

```
storageexplorer://v=1&accountid=%2Fsubscriptions%2F3bd4723e-ab5f-41bd-90c1-0e8b8a944536%2FresourceGroups%2FBackups%2Fproviders%2FMicrosoft.Storage%2FstorageAccounts%2Fnasbackup16&subscriptionid=3bd4723e-ab5f-41bd-90c1-0e8b8a944536&resourcetype=Azure.BlobContainer&resourcename=vaultwarden-backup
```

## Update containerapp in Azure (manually)

```ps1
az containerapp update --name managedEnvironment-VaultWarden-9bfb --resource-group VaultWarden \
    --yaml app.yaml
```

## Building the custom container image

```sh
cd ./vaultwarden_cust
docker build -t vaultwarden_mp --build-arg tag=1.32.4-alpine .
```

### Running the container

```sh
docker run --name vaultwarden -v /vw-data/:/data_back/ -p 8080:80 vaultwarden/server_mp:1.32.4-alpine
```

## Revision Log

### [29-05-22] SQLite db is backuped and restored to mounted AzureStorage volume

* switched to a custom created container image with modified `startup.sh`
* it copies SQLite db from mounted volume at startup and backs it up again on shutdown
* this works as long as there is only a single replica (otherwise a temp volume has to be used)

### [27-05-22] Disable locking SQLite db

* mounting storage location from Azure Storage (CIFS) does not allow locking the db
* see [link to github discussion](https://github.com/dani-garcia/vaultwarden/issues/1201#issuecomment-716804769)
* Error: `[2022-05-26 09:55:13.850][panic][ERROR] thread 'main' panicked at 'Failed to turn on WAL: DatabaseError(__Unknown, "database is locked")': src/db/mod.rs:445`
