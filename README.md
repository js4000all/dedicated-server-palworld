# palworld_server
Palworld Dedicated Server Container

This is my practice work and it's not refined.


## Recommended

* https://github.com/jammsen/docker-palworld-dedicated-server
  * It's authentic. However, it might be a bit intricate.
* https://github.com/KagurazakaNyaa/palworld-docker
  * It's simple, but practical enough.


# How to Use

## Generate the Palworld Server Settings

Copy `palworld.conf.example` to `palworld.conf`, then edit it to match your server configuration.

Generate `PalWorldSettings.ini` with the following command:

```bash
./generate-settings.sh > saved/Config/LinuxServer/PalWorldSettings.ini
```

## Start the Server

Start the server in the background with Docker Compose:

```bash
docker compose up -d
```
