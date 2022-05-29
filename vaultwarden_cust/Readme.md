# Readme

Image customizes `startup.sh` ([original on github](https://github.com/dani-garcia/vaultwarden/blob/main/docker/start.sh)) to backup SQLite db on mounted share and restores it before spinning up the container.

## Building the image

```sh
docker build -t vaultwarden/server_mp:1.25.0-alpine .
```

## Running the container

```sh
docker run --name vaultwarden -v /vw-data/:/data_back/ -p 8080:80 vaultwarden/server_mp:1.25.0-alpine
```
