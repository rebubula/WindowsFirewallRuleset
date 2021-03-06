
<#
MIT License

This file is part of "Windows Firewall Ruleset" project
Homepage: https://github.com/metablaster/WindowsFirewallRuleset

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
Get all firewall rules with LocalUser value
.DESCRIPTION
Get all rules which are either missing or not missing LocalUser value
Rules which are missing LocalUser are considered weak and need to be updated
This operation is slow, intended for debugging.
.PARAMETER Empty
If specified returns rules with no local user value
Otherwise only rules with local user are returned
.EXAMPLE
PS> Find-RulePrincipal -Empty
.INPUTS
None. You cannot pipe objects to Find-RulePrincipal
.OUTPUTS
None.
.NOTES
TODO: This needs improvement to export matching rules to JSON
#>
function Find-RulePrincipal
{
	[CmdletBinding()]
	param (
		[Parameter()]
		[switch] $Empty
	)

	Write-Debug -Message "[$($MyInvocation.InvocationName)] params($($PSBoundParameters.Values))"

	Write-Information -Tags "User" -MessageData "INFO: Getting rules from GPO..."
	$GPORules = Get-NetFirewallProfile -All -PolicyStore $PolicyStore |
	Get-NetFirewallRule | Where-Object -Property Owner -EQ $null

	Write-Information -Tags "User" -MessageData "INFO: Applying security filter..."
	$UserFilter = $GPORules | Get-NetFirewallSecurityFilter |
	Where-Object -Property LocalUser -EQ Any

	Write-Information -Tags "User" -MessageData "INFO: Applying service filter..."
	$ServiceFilter = $UserFilter | Get-NetFirewallRule |
	Get-NetFirewallServiceFilter | Where-Object -Property Service -EQ Any

	Write-Information -Tags "User" -MessageData "INFO: Selecting properties..."
	$TargetRules = $ServiceFilter | Get-NetFirewallRule |
	Select-Object -Property DisplayName, DisplayGroup, Direction

	$TargetRules | Format-List
}
