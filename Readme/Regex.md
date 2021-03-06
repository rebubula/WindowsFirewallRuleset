
# Regex expressions for quick project wide actions

A list of regex expressions which are used to perform bulk operations against the rules inside the
project.

For example once your regex hits, you would use CTRL + SHIFT + L to enter
[Multi cursor](https://code.visualstudio.com/docs/getstarted/tips-and-tricks#_multi-cursor-selection)
mode\
and manipulate all regex matches however you like.

Note:

- firewall rule examples here are shortened.
- each regex includes an optional space at the end

## Table of contents

- [Regex expressions for quick project wide actions](#regex-expressions-for-quick-project-wide-actions)
  - [Table of contents](#table-of-contents)
  - [Get -DisplayName parameter and it's value](#get--displayname-parameter-and-its-value)
  - [Get platform](#get-platform)
  - [Get group](#get-group)
  - [Get Interface](#get-interface)
  - [Get Profile property if value also contains variable names](#get-profile-property-if-value-also-contains-variable-names)
  - [Direction protocol pairs](#direction-protocol-pairs)
  - [Get local and remote port parameters and values](#get-local-and-remote-port-parameters-and-values)
  - [Get mapping pairs and their values](#get-mapping-pairs-and-their-values)
  - [Get LocalUser and EdgeTraversalPolicy](#get-localuser-and-edgetraversalpolicy)
  - [Get local and remote IPv6 address only in any notation](#get-local-and-remote-ipv6-address-only-in-any-notation)
  - [Get local and remote IPv4 address only in any notation](#get-local-and-remote-ipv4-address-only-in-any-notation)
  - [Get owner and package for store app](#get-owner-and-package-for-store-app)

## Get -DisplayName parameter and it's value

In below example multi cursor-ing all the matches in a script would allow to cut and paste all
regex matches onto a second line by using CTRL + X, Down Arrow to move and CTRL + V.

```powershell
New-NetFirewallRule -DisplayName "Interface-Local Multicast" -Service Any `
New-NetFirewallRule -DisplayName $_.Name -Service Any `
```

```regex
-DisplayName "(.*)"(?= -Service) ?
-DisplayName ("(.*)"|\$_\.\w+)(?= -Service) ?
```

[//]: # (Platform)

## Get platform

```powershell
-Platform $Platform
```

```regex
-Platform \$Platform ?
```

## Get group

```powershell
New-NetFirewallRule -Group $Group
New-NetFirewallRule -Group "Some rule group"
```

```regex
-Group (([\$|\w]\w+)|(".*")) ?
```

## Get Interface

```powershell
New-NetFirewallRule -InterfaceType $Interface
New-NetFirewallRule -InterfaceType "Wired, Wireless"
# TODO: is this valid? if yes regex needs update
New-NetFirewallRule -InterfaceType Wired, Wireless
```

```regex
-InterfaceType (([\$|\w]\w+)|(".*")) ?
```

[//]: # (PolicyStore)

## Get Profile property if value also contains variable names

```powershell
New-NetFirewallRule -Profile Any
New-NetFirewallRule -Profile $FirewallProfile
New-NetFirewallRule -Profile Private, Domain
```

```regex
-Profile [\$|\w]\w+,? ?\w+ ?
```

## Direction protocol pairs

```powershell
New-NetFirewallRule -Direction $Direction -Protocol UDP
New-NetFirewallRule -Direction Inbound -Protocol 41
-Direction $Direction -Protocol ICMPv4 -IcmpType 12
```

```regex
-Direction [\$|\w]\w+ -Protocol [\$|\w]\w+ ?
-Direction [\$|\w]\w+ -Protocol [\$|\w]\w+ -IcmpType \d+ ?
 ```

## Get local and remote port parameters and values

```powershell
New-NetFirewallRule -LocalPort Any -RemotePort 547, 53
New-NetFirewallRule -LocalPort 546 -RemotePort IPHTTPSout
New-NetFirewallRule -LocalPort 22, 546-55, 54 -RemotePort Any
```

```regex
-LocalPort [\w&&,&&\-&& ]+ -RemotePort [\w&&,&&\-&& ]+ ?
```

## Get mapping pairs and their values

```powershell
New-NetFirewallRule -LocalOnlyMapping $false -LooseSourceMapping $false
New-NetFirewallRule -LocalOnlyMapping $true -LooseSourceMapping $false
```

```regex
-LocalOnlyMapping \$(false|true) -LooseSourceMapping \$(false|true) ?
 ```

[//]: # (If needed)

## Get LocalUser and EdgeTraversalPolicy

```powershell
# TODO: can also be function call for SDDL
New-NetFirewallRule -LocalUser $UsersGroupSDDL -EdgeTraversalPolicy DeferToApp
New-NetFirewallRule -LocalUser Any -EdgeTraversalPolicy DeferToApp
```

```regex
-LocalUser [\$|\w]\w+ -EdgeTraversalPolicy \w+ ?
```

## Get local and remote IPv6 address only in any notation

```powershell
New-NetFirewallRule -LocalAddress ff01::/16 -RemoteAddress Any
New-NetFirewallRule -LocalAddress Any -RemoteAddress ff01::2
```

```regex
-LocalAddress (?!.*\.)[\w&&:&&/]+ -RemoteAddress (?!.*\.)[\w&&:&&/]+ ?
```

## Get local and remote IPv4 address only in any notation

```powershell
New-NetFirewallRule -LocalAddress 224.3.0.44, 224.0.0.0-224.0.0.255, 224.3.0.44 -RemoteAddress Any
New-NetFirewallRule -LocalAddress LocalSubnet4 -RemoteAddress 224.3.0.44, 224.0.0.0-224.0.0.255
New-NetFirewallRule -LocalAddress LocalSubnet4 -RemoteAddress 224.3.0/24, 224.0/16-224.0.0.255
```

```regex
-LocalAddress (?!.*:)[,\.\w \-/]+ -RemoteAddress (?!.*:)[,\.\w \-/]+ ?
```

## Get owner and package for store app

```powershell
New-NetFirewallRule -Owner (Get-GroupSID "Administrators") -Package "*"
New-NetFirewallRule -Owner $Principal.SID -Package $PackageSID
```

```regex
-Owner [\$|\w](\w|\.)+(?= -Package) -Package [\$|\w](\w|\.)+ ?
-Owner (([\$|\w](\w|\.)+)|(\(.*\))) -Package ([\$|\w](\w|\.)+|".*") ?
```
