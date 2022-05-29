# Readme

## Building the image

```sh
docker build -t vaultwarden/server_mp:1.25.0-alpine .
```

## Running the container

```sh
docker run --name vaultwarden -v /vw-data/:/data_back/ -p 8080:80 vaultwarden/server_mp:1.25.0-alpine
```