
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
Strip computer names out of computer accounts
.DESCRIPTION
ConvertFrom-UserAccount is a helper method to reduce typing common code
related to splitting up user accounts
.PARAMETER UserAccounts
Array of user accounts in form of: COMPUTERNAME\USERNAME
.EXAMPLE
ConvertFrom-UserAccounts COMPUTERNAME\USERNAME
.EXAMPLE
ConvertFrom-UserAccounts SERVER\USER, COMPUTER\USER, SERVER2\USER2
.INPUTS
None. You cannot pipe objects to ConvertFrom-UserAccounts
.OUTPUTS
[string[]] array of usernames in form of: USERNAME
.NOTES
None.
#>
function ConvertFrom-UserAccount
{
	[OutputType([System.String[]])]
	[CmdletBinding()]
	param(
		[Alias("Account")]
		[Parameter(Mandatory = $true)]
		[string[]] $UserAccounts
	)

	Write-Debug -Message "[$($MyInvocation.InvocationName)] params($($PSBoundParameters.Values))"

	[string[]] $UserNames = @()
	foreach ($Account in $UserAccounts)
	{
		Write-Verbose -Message "[$($MyInvocation.InvocationName)] Getting user name for account: $Account"
		$UserNames += $Account.split("\")[1]
	}

	return $UserNames
}
