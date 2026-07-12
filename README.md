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

# Notes when running this container on WSL

The following configuration is required to make the dedicated server reachable from other devices through the Windows host's IP address.

For example, assume that:

* The Windows PC running WSL has the LAN IP address `192.168.1.2`.
* The dedicated server container listens on UDP port `8211`.
* A client outside the Windows PC connects to `192.168.1.2:8211`.

## 1. Configure WSL networking

This setup requires WSL mirrored networking.

Create or edit the following file on Windows:

```text
%USERPROFILE%\.wslconfig
```

Add the following configuration:

```ini
[wsl2]
networkingMode=mirrored
firewall=false

[experimental]
hostAddressLoopback=true
```

The settings have the following purposes:

* `networkingMode=mirrored` allows WSL services to use the network interfaces and IP addresses assigned to the Windows host.
* `firewall=false` disables WSL's Hyper-V firewall integration. Firewall access must instead be controlled by the regular Windows firewall or a third-party firewall.
* `hostAddressLoopback=true` allows the Windows host to access the WSL service through the host's own LAN IP address, such as `192.168.1.2`.

`hostAddressLoopback` must be placed in the `[experimental]` section.

After changing `.wslconfig`, completely stop WSL from PowerShell:

```powershell
wsl --shutdown
```

## 2. Configure the Windows or third-party firewall

Allow inbound UDP traffic to port `8211` on the Windows PC.

For Windows Defender Firewall, an administrator can create the rule from PowerShell:

```powershell
New-NetFirewallRule `
  -DisplayName "Palworld Dedicated Server UDP 8211" `
  -Direction Inbound `
  -Action Allow `
  -Protocol UDP `
  -LocalPort 8211
```

When using a third-party firewall, such as ESET, create an equivalent rule:

```text
Direction: Inbound
Protocol: UDP
Local port: 8211
Action: Allow
```

Limit the allowed remote addresses to the local network when appropriate. For example:

```text
192.168.1.0/24
```

## 3. Connect to the server

Clients on the same network can connect using the Windows host's LAN IP address:

```text
192.168.1.2:8211
```

The expected traffic path is:

```text
Client
  -> Windows host 192.168.1.2:8211/UDP
  -> WSL mirrored network
  -> Docker port mapping
  -> Dedicated server container:8211/UDP
```

### Internet access

The instructions above allow access from other devices that can already reach the Windows PC, such as devices on the same LAN.

To accept connections from the Internet, also configure the router to forward UDP port `8211` to the Windows PC:

```text
WAN UDP 8211
  -> 192.168.1.2 UDP 8211
```
