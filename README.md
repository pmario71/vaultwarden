# vaultwarden

* [dani-garcia/vaultwarden: Unofficial Bitwarden compatible server written in Rust, formerly known as bitwarden_rs (github.com)](https://github.com/dani-garcia/vaultwarden)
* alpine-based Images for VaultWarden:  [vaultwarden/server Tags | Docker Hub](https://hub.docker.com/r/vaultwarden/server/tags?name=alpine)


## Todo

* [x] Mounting `/data` from Azure Storage (see [link to ContainerApp docs](https://docs.microsoft.com/en-us/azure/container-apps/storage-mounts?pivots=aca-cli#configuration-1))
  * mounting `/data` from Azure Blobstorage directly does not work (SQLite fails to lock files)

* [x] disable creation of new user accounts
* [x] enable health checks
* [x] Import existing passwords
* [ ] enable browser plugins
* [x] backup through `Azure App Service` environment enabled

## Update Process

* change `SOURCE_IMAGE_TAG` to new version in `container_version.env`
* trigger github action run `build container image`
* new version of container image shall be picked up automatically
  * otherwise select newly published image in `Azure App Service portal` (Deployment / Deployment Center)

### Validate deployed version

* at login:
  ```ps1
  Vaultwarden Web
  2025.7
  ```

* call API:\
  https://vaultwarden-asehgccdcthab6fa.germanywestcentral-01.azurewebsites.net/api/version

## References

* [Deploy containers from github actions](https://learn.microsoft.com/en-us/azure/app-service/deploy-container-github-action?tabs=publish-profile&pivots=github-actions-containers-linux)
