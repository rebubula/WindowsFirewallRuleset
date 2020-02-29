
<#
MIT License

Project: "Windows Firewall Ruleset" serves to manage firewall on Windows systems
Homepage: https://github.com/metablaster/WindowsFirewallRuleset

Copyright (C) 2013, 2016 Boe Prox
Copyright (C) 2016 Warren Frame
Copyright (C) 2020 metablaster zebal@protonmail.ch

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
#>

<#
.SYNOPSIS
Retrieves SQL server information from a local or remote servers.
.DESCRIPTION
Retrieves SQL server information from a local or remote servers. Pulls all
instances from a SQL server and detects if in a cluster or not.
.PARAMETER ComputerNames
Local or remote systems to query for SQL information.
.PARAMETER CIM
If specified, try to pull and correlate CIM information for SQL

I've done limited testing in matching up the service info to registry info.
Suggestions would be appreciated!
.EXAMPLE
Get-SQLInstances -Computername DC1

SQLInstance   : MSSQLSERVER
Version       : 10.0.1600.22
isCluster     : False
Computername  : DC1
FullName      : DC1
isClusterNode : False
Edition       : Enterprise Edition
ClusterName   :
ClusterNodes  : {}
Caption       : SQL Server 2008

SQLInstance   : MINASTIRITH
Version       : 10.0.1600.22
isCluster     : False
Computername  : DC1
FullName      : DC1\MINASTIRITH
isClusterNode : False
Edition       : Enterprise Edition
ClusterName   :
ClusterNodes  : {}
Caption       : SQL Server 2008

Description
-----------
Retrieves the SQL information from DC1
.EXAMPLE
#Get SQL instances on servers 1 and 2, match them up with service information from CIM
Get-SQLInstances -Computername Server1, Server2 -CIM

Computername     : Server1
SQLInstance      : MSSQLSERVER
SQLBinRoot       : D:\MSSQL11.MSSQLSERVER\MSSQL\Binn
Edition          : Enterprise Edition: Core-based Licensing
Version          : 11.0.3128.0
Caption          : SQL Server 2012
isCluster        : False
isClusterNode    : False
ClusterName      :
ClusterNodes     : {}
FullName         : Server1
ServiceName      : SQL Server (MSSQLSERVER)
ServiceState     : Running
ServiceAccount   : domain\Server1SQL
ServiceStartMode : Auto

Computername     : Server2
SQLInstance      : MSSQLSERVER
SQLBinRoot       : D:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\Binn
Edition          : Enterprise Edition
Version          : 10.50.4000.0
Caption          : SQL Server 2008 R2
isCluster        : False
isClusterNode    : False
ClusterName      :
ClusterNodes     : {}
FullName         : Server2
ServiceName      : SQL Server (MSSQLSERVER)
ServiceState     : Running
ServiceAccount   : domain\Server2SQL
ServiceStartMode : Auto
.FUNCTIONALITY
	Computers
.NOTES
Name: Get-SQLInstances
Author: Boe Prox, edited by cookie monster (to cover wow6432node, CIM tie in)

Version History:
1.5 //Boe Prox - 31 May 2016
	- Added CIM queries for more information
	- Custom object type name
1.0 //Boe Prox -  07 Sept 2013
	- Initial Version

Following modifications by metablaster based on both originals 15 Feb 2020:
- change syntax, casing, code style and function name
- resolve warnings, replacing aliases with full names
- change how function returns
- Add code to return SQL DTS Path
- separate support for 32 bit systems
- Include license into file (MIT all 3), links to original sites and add appropriate Copyright for each author/contributor
- update reported server versions
- added more verbose and debug output, path formatting.
- Replaced WMI calls with CIM calls which are more universal and cross platfrom that WMI

Links to original and individual versions of code
https://github.com/RamblingCookieMonster/PowerShell
https://github.com/metablaster/WindowsFirewallRuleset
https://gallery.technet.microsoft.com/scriptcenter/Get-SQLInstance-9a3245a0

TODO: update examples to include DTS directory
#>
function Get-SQLInstances
{
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias("Servers", "Machines")]
		[string[]] $ComputerNames = [System.Environment]::MachineName,
		[switch] $CIM
	)

	begin
	{
		# TODO: begin scope for all registry functions
		$RegistryHive = [Microsoft.Win32.RegistryHive]::LocalMachine

		if ([System.Environment]::Is64BitOperatingSystem)
		{
			# 64 bit system
			$HKLM = @(
				"SOFTWARE\Microsoft\Microsoft SQL Server"
				"SOFTWARE\Wow6432Node\Microsoft\Microsoft SQL Server")
		}
		else
		{
			# 32 bit system
			$HKLM = "SOFTWARE\Microsoft\Microsoft SQL Server"
		}
	}

	process
	{
		Write-Debug -Message "[$($MyInvocation.InvocationName)] params($($PSBoundParameters.Values))"

		[PSCustomObject[]] $AllInstances = @()
		foreach ($Computer in $ComputerNames)
		{
			# TODO: what is this?
			$Computer = $Computer -replace '(.*?)\..+', '$1'
			Write-Verbose -Message "[$($MyInvocation.InvocationName)] Contacting computer: $Computer"

			if (!(Test-Connection -ComputerName $Computer -Count 2 -Quiet))
			{
				Write-Error -Category ConnectionError -TargetObject $Computer -Message "Unable to contact '$Computer'"
				continue
			}

			try
			{
				Write-Verbose -Message "[$($MyInvocation.InvocationName)] Accessing registry on computer: $Computer"
				$RemoteKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($RegistryHive, $Computer)
			}
			catch
			{
				Write-Error -TargetObject $Computer -Message $_
				continue
			}

			foreach ($HKLMRootKey in $HKLM)
			{
				# TODO: add COMPUTERNAME for all keys in all registry functions
				Write-Verbose -Message "[$($MyInvocation.InvocationName)] Opening root key: HKLM:$HKLMRootKey"
				$RootKey = $RemoteKey.OpenSubKey($HKLMRootKey)

				if (!$RootKey)
				{
					Write-Warning -Message "Failed to open registry root key: $HKLMRootKey"
					continue
				}

				if ($RootKey.GetSubKeyNames() -contains "Instance Names")
				{
					Write-Verbose -Message "[$($MyInvocation.InvocationName)] Opening sub key: Instance Names\SQL"
					$RootKey = $RemoteKey.OpenSubKey("$HKLMRootKey\Instance Names\SQL")

					if ($RootKey)
					{
						$Instances = @($RootKey.GetValueNames())
					}
					else
					{
						Write-Warning -Message "Failed to open registry sub key: Instance Names\SQL"
					}
				}
				elseif ($RootKey.GetValueNames() -contains 'InstalledInstances')
				{
					$isCluster = $false
					$Instances = $RootKey.GetValue('InstalledInstances')
				}
				else
				{
					continue
				}

				if ($Instances.Count -gt 0)
				{
					foreach ($Instance in $Instances)
					{
						$ClusterName = $null
						$isCluster = $false
						$InstanceValue = $RootKey.GetValue($Instance)
						$Nodes = New-Object -TypeName System.Collections.Arraylist

						Write-Verbose -Message "[$($MyInvocation.InvocationName)] Opening InstanceReg key: $HKLMRootKey\$InstanceValue"
						$InstanceReg = $RemoteKey.OpenSubKey("$HKLMRootKey\$InstanceValue")

						if (!$InstanceReg)
						{
							Write-Warning -Message "Failed to open InstanceReg key: $HKLMRootKey\$InstanceValue"
							continue
						}

						if ($InstanceReg.GetSubKeyNames() -contains "Cluster")
						{
							$isCluster = $true

							Write-Verbose -Message "[$($MyInvocation.InvocationName)] Opening InstanceRegCluster sub key: Cluster"
							$InstanceRegCluster = $InstanceReg.OpenSubKey('Cluster')

							if ($InstanceRegCluster)
							{
								$ClusterName = $InstanceRegCluster.GetValue('ClusterName')
							}
							else
							{
								Write-Warning "Failed to open InstanceRegCluster sub key: Cluster"
							}

							Write-Verbose -Message "[$($MyInvocation.InvocationName)] Opening ClusterReg key: $HKLMRootKey\$InstanceValue\Cluster\Nodes"
							# TODO: this should probably be $InstanceReg.OpenSubKey("Cluster\Nodes") ?
							Write-Debug -Message "TODO: this doesn't look good!"
							$ClusterReg = $RemoteKey.OpenSubKey("Cluster\Nodes")

							if ($ClusterReg)
							{
								$ClusterReg.GetSubKeyNames() | ForEach-Object {
									# TODO: check opening sub key
									$Nodes.Add($ClusterReg.OpenSubKey($_).GetValue('NodeName')) | Out-Null
								}
							}
							else
							{
								Write-Warning "Failed to open ClusterReg key: $HKLMRootKey\$InstanceValue\Cluster\Nodes"
							}
						}

						Write-Verbose -Message "[$($MyInvocation.InvocationName)] Opening InstanceRegSetup key: $HKLMRootKey\$InstanceValue\Setup"
						$InstanceRegSetup = $InstanceReg.OpenSubKey("Setup")

						if ($InstanceRegSetup)
						{
							$Edition = $InstanceRegSetup.GetValue('Edition')
							$SQLBinRoot = $InstanceRegSetup.GetValue('SQLBinRoot')

							if ([string]::IsNullOrEmpty($SQLBinRoot))
							{
								Write-Warning -Message "Failed to read registry key entry 'SQLBinRoot' for SQL Binn directory"
							}
							else
							{
								$SQLBinRoot = Format-Path $SQLBinRoot
							}
						}
						else
						{
							Write-Warning -Message "Failed to open InstanceRegSetup sub key: $HKLMRootKey\$InstanceValue\Setup"
							continue
						}

						try
						{
							Write-Debug "Settings ErrorActionPreference to: Stop"
							$ErrorActionPreference = "Stop"

							# Get from filename to determine version
							Write-Verbose -Message "[$($MyInvocation.InvocationName)] Opening ServicesReg key: HKLM:SYSTEM\CurrentControlSet\Services"
							$ServicesReg = $RemoteKey.OpenSubKey("SYSTEM\CurrentControlSet\Services")

							if (!$ServicesReg)
							{
								Write-Warning "Failed to open ServiceReg key: HKLM:SYSTEM\CurrentControlSet\Services"
							}
							else
							{
								$ServiceKey = $ServicesReg.GetSubKeyNames() | Where-Object {
									$_ -match "$Instance"
								} | Select-Object -First 1

								Write-Verbose -Message "[$($MyInvocation.InvocationName)] Opening Service sub key: $ServiceKey"
								$Service = $ServicesReg.OpenSubKey($ServiceKey).GetValue('ImagePath')

								if ($Service)
								{
									$File = $Service -replace '^.*(\w:\\.*\\sqlservr.exe).*', '$1'
									$Version = (Get-Item ("\\$Computer\$($File -replace ":", "$")")).VersionInfo.ProductVersion
								}
								else
								{
									Write-Warning "Failed to open Service sub key: $ServiceKey"
								}
							}
						}
						catch
						{
							# Use potentially less accurate version from registry
							$Version = $InstanceRegSetup.GetValue('Version')
						}
						finally
						{
							Write-Debug "Restoring ErrorActionPreference to Continue"
							$ErrorActionPreference = "Continue"
						}

						# Get SQL DTS Path
						$Major, $Minor, $Build, $Revision = $Version.Split(".")
						Write-Verbose -Message "[$($MyInvocation.InvocationName)] Opening sub key: $HKLMRootKey\$Major$Minor"
						$VersionKey = $RemoteKey.OpenSubKey("$HKLMRootKey\$Major$Minor")

						if ($VersionKey)
						{
							if ($VersionKey.GetSubKeyNames() -contains "DTS")
							{
								Write-Verbose -Message "[$($MyInvocation.InvocationName)] Opening DTSKey sub key: DTS\Setup"
								$DTSKey = $VersionKey.OpenSubKey("DTS\Setup")

								if ($DTSKey)
								{
									$SQLPath = $DTSKey.GetValue("SQLPath")

									if ([string]::IsNullOrEmpty($SQLPath))
									{
										Write-Warning -Message "Failed to read registry key entry 'SQLPath' for SQL DTS Path"
									}
									else
									{
										$SQLPath = Format-Path $SQLPath
									}
								}
								else
								{
									Write-Warning "Failed to open DTSKey sub key: DTS\Setup"
								}
							}
						}
						else
						{
							Write-Warning "Failed to open VersionKey sub key: $HKLMRootKey\$Major$Minor"
						}

						$AllInstances += [PSCustomObject]@{
							"Computername" = $Computer
							"SQLInstance" = $Instance
							"SQLBinRoot" = $SQLBinRoot
							"SQLPath" = $SQLPath
							"Edition" = $Edition
							"Version" = $Version

							Caption = {
								switch -Regex ($Version)
								{
									# https://en.wikipedia.org/wiki/History_of_Microsoft_SQL_Server
									"^15"	{ 'SQL Server 2019'; break }
									"^14"	{ 'SQL Server 2017'; break }
									"^13"	{ 'SQL Server 2016'; break }
									"^12"	{ 'SQL Server 2014'; break }
									"^11"	{ 'SQL Server 2012'; break }
									"^10\.5" { 'SQL Server 2008 R2'; break }
									"^10"	{ 'SQL Server 2008'; break }
									"^9"	{ 'SQL Server 2005'; break }
									"^8"	{ 'SQL Server 2000'; break }
									"^7"	{ 'SQL Server 7.0'; break }
									default { 'Unknown' }
								}
							}.InvokeReturnAsIs()

							isCluster = $isCluster
							isClusterNode = ($Nodes -contains $Computer)
							ClusterName = $ClusterName
							ClusterNodes = ($Nodes -ne $Computer)

							FullName = {
								if ($Instance -eq 'MSSQLSERVER')
								{
									$Computer
								}
								else
								{
									"$($Computer)\$($Instance)"
								}
							}.InvokeReturnAsIs()
						}
					} # foreach ($Instance in $Instances)
				} # $Instances.Count -gt 0
			} # foreach($HKLMRootKey in $HKLM)

			# If the CIM param was specified, get CIM info and correlate it!
			# Will not work with PowerShell core.
			if ($CIM)
			{
				[PSCustomObject[]] $AllInstancesCIM = @()

				try
				{
					# Get the CIM info we care about.
					$SQLServices = $null # TODO: what does this mean?
					$SQLServices = @(
						Get-CimInstance -ComputerName $Computer -ErrorAction stop `
							-Query "select DisplayName, Name, PathName, StartName, StartMode, State from win32_service where Name LIKE 'MSSQL%'" |
						# This regex matches MSSQLServer and MSSQL$*
						Where-Object { $_.Name -match "^MSSQL(Server$|\$)" } |
						Select-Object -Property DisplayName, StartName, StartMode, State, PathName
					)

					# If we pulled CIM info and it wasn't empty, correlate!
					if ($SQLServices)
					{
						Write-Debug "CIM service info:`n$($SQLServices | Format-List -Property * | Out-String)"

						foreach ($Instance in $AllInstances)
						{
							$MatchingService = $SQLServices |
							Where-Object {
								# We need to format here because Instance path is formated, while the path from CIM query isn't
								# TODO: can be improved by formatting when all is done, ie. at the end before returning.
								(Format-Path $_.PathName) -like "$( $Instance.SQLBinRoot )*" -or $_.PathName -like "`"$( $Instance.SQLBinRoot )*"
							} | Select-Object -First 1

							Write-Debug "Matching service info:`n$($MatchingService | Format-List -Property * | Out-String)"

							$AllInstancesCIM += $Instance | Select-Object -Property Computername,
							SQLInstance,
							SQLBinRoot,
							SQLPath,
							Edition,
							Version,
							Caption,
							isCluster,
							isClusterNode,
							ClusterName,
							ClusterNodes,
							FullName,
							@{
								label = "ServiceName"; expression = {
									if ($MatchingService)
									{
										$MatchingService.DisplayName
									}
									else
									{
										"No CIM Match"
									}
								}
							},
							@{
								label = "ServiceState"; expression = {
									if ($MatchingService)
									{
										$MatchingService.State
									}
									else
									{
										"No CIM Match"
									}
								}
							},
							@{
								label = "ServiceAccount"; expression = {
									if ($MatchingService)
									{
										$MatchingService.StartName
									}
									else
									{
										"No CIM Match"
									}
								}
							},
							@{
								label = "ServiceStartMode"; expression = {
									if ($MatchingService)
									{
										$MatchingService.StartMode
									}
									else
									{
										"No CIM Match"
									}
								}
							}
						} # foreach($Instance in $AllInstances)
					} # if($SQLServices)
				}
				catch
				{
					Write-Error -TargetObject $_.TargetObject -Message "Could not retrieve CIM info for computer $Computer, $_"
					Write-Output $AllInstances
					return
				}

				Write-Output $AllInstancesCIM
			} # if CIM
			else
			{
				Write-Output $AllInstances
			}
		}
	}
}
