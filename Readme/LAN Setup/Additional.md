
# Additional Settings

1. NTLM authentication is still supported and must be used for Windows authentication with systems
   configured as a member of a workgroup.

   - NTLM authentication is also used for local logon authentication on non-domain controllers.

2. NTLM is still used in the following situations:

   - No Active Directory domain exists (commonly referred to as "workgroup" or "peer-to-peer")

3. Windows Internet Name Service (WINS) is a legacy computer name registration and resolution service
   that maps computer NetBIOS names to IP addresses.

4. If you don't already have WINS deployed on your network, do not deploy WINS

## Services

- Link-layer topology discovery mapper (to auto)
- print spooler (to auto)
- Internet connection sharing (to auto)
- IP Translation configuration (to auto)

## Troubleshooting discovery

- again Settings -> System -> System info -> Advanced system settings ->
  Computer name -> Network ID -> this is home computer
- Function Discovery Resource Publication to delayed start (or just restart for quick effect)
- disable IPv6 (may cause unresponsiveness if router does not support IPv6)
- Internet Protocol Version 4 (TCP/IPv4) -> WINS -> Enable LMHOSTS lookup
- Remove/uninstall unneeded virtual adapters.

## Make This PC Discoverable in PC settings

INFO: probably point 3 does that implicitly

- The Make this PC discoverable setting will not be available if you have UAC set to Always notify.
- Setting UAC to a different level will allow Make this PC discoverable settings to be available.
- The Make this PC discoverable setting will not be available if you have created a Hyper-V virtual switch
- with this Ethernet connection.

## Troubleshoot name resolution (discovery)

```powershell
nbtstat -c
nbtstat -r
netview
```

## more discovery tools

- restart on both PC's function discovery resource publication
- restart on both PC's computer browser
