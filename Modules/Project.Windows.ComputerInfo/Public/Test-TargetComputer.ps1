
<#
MIT License

This file is part of "Windows Firewall Ruleset" project
Homepage: https://github.com/metablaster/WindowsFirewallRuleset

Copyright (C) 2019, 2020 metablaster zebal@protonmail.ch

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
Test target computer (policy store) on which to apply firewall
.DESCRIPTION
The purpose of this function is to reduce typing checks depending on whether PowerShell
core or desktop edition is used, since parameters for Test-Connection are not the same
for both PowerShell editions.
.PARAMETER ComputerName
Target computer which to test
.PARAMETER Count
Valid only for PowerShell Core. Specifies the number of echo requests to send. The default value is 4
.PARAMETER Timeout
Valid only for PowerShell Core. The test fails if a response isn't received before the timeout expires
.EXAMPLE
Test-TargetComputer "COMPUTERNAME" 2 1
.EXAMPLE
Test-TargetComputer "COMPUTERNAME"
.INPUTS
None. You cannot pipe objects to Test-TargetMachine
.OUTPUTS
[bool] false or true if target host is responsive
.NOTES
TODO: avoid error message, check all references which handle errors (code bloat)
TODO: this should probably be part of ComputerInfo module
#>
function Test-TargetComputer
{
	[OutputType([bool])]
	[CmdletBinding(PositionalBinding = $false)]
	param (
		[Alias("Computer", "Server", "Domain", "Host", "Machine")]
		[Parameter(Mandatory = $true,
			Position = 0)]
		[string] $ComputerName,

		[Parameter()]
		[int16] $Count = $ConnectionCount,

		[Parameter()]
		[int16] $Timeout = $ConnectionTimeout
	)

	Write-Debug -Message "[$($MyInvocation.InvocationName)] params($($PSBoundParameters.Values))"
	Write-Information -Tags "User" -MessageData "INFO: Contacting computer $ComputerName"

	# Test parameters depend on PowerShell edition
	# TODO: changes not reflected in calling code
	# NOTE: Don't suppress error, error details can be of more use than just "unable to contact computer"
	if ($PSVersionTable.PSEdition -eq "Core")
	{
		return Test-Connection -TargetName $ComputerName -Count $Count -TimeoutSeconds $Timeout -IPv4 -Quiet
	}

	return Test-Connection -ComputerName $ComputerName -Count $Count -Quiet
}
