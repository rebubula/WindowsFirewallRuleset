
<#
MIT License

Project: "Windows Firewall Ruleset" serves to manage firewall on Windows systems
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

#
# Unit test for Find-Installation
#
[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
	'PSAvoidGlobalVars', '', Justification = 'Global variable used for testing only')]
param()

. $PSScriptRoot\..\..\Config\ProjectSettings.ps1

if ((Get-Variable -Name Develop -Scope Global).Value -eq $false)
{
	Write-Error -Category NotEnabled -TargetObject "Variable 'Develop'" `
		-Message "This unit test is enabled only when 'Develop' is set to $true"
	return
}

# Check requirements for this project
Import-Module -Name Project.AllPlatforms.System
Test-SystemRequirements

# Imports
. $PSScriptRoot\ContextSetup.ps1
Import-Module -Name Project.AllPlatforms.Logging
Import-Module -Name Project.AllPlatforms.Test @Logs
Import-Module -Name Project.Windows.ProgramInfo @Logs
Import-Module -Name Project.AllPlatforms.Utility @Logs

# Ask user if he wants to load these rules
Update-Context $TestContext $($MyInvocation.MyCommand.Name -replace ".{4}$") @Logs
if (!(Approve-Execute @Logs)) { exit }

Start-Test

New-Test "Find-Installation 'EdgeChromium'"
Find-Installation "EdgeChromium" @Logs
$global:InstallTable | Format-Table -AutoSize @Logs

New-Test "Install Root EdgeChromium"
$global:InstallTable | Select-Object -ExpandProperty InstallLocation @Logs

New-Test "Find-Installation 'TeamViewer'"
Find-Installation "TeamViewer" @Logs
$global:InstallTable | Format-Table -AutoSize @Logs

New-Test "Find-Installation 'FailureTest'"
Find-Installation "FailureTest" @Logs
$global:InstallTable | Format-Table -AutoSize @Logs

New-Test "Find-Installation 'VisualStudio'"
Find-Installation "VisualStudio" @Logs
$global:InstallTable | Format-Table -AutoSize @Logs

New-Test "Find-Installation 'Greenshot'"
Find-Installation "Greenshot" @Logs
$global:InstallTable | Select-Object -ExpandProperty InstallLocation @Logs

New-Test "Install Root Greenshot"
$global:InstallTable | Select-Object -ExpandProperty InstallLocation @Logs

New-Test "Find-Installation 'OneDrive'"
Find-Installation "OneDrive" @Logs
$global:InstallTable | Format-Table -AutoSize @Logs

New-Test "Install Root OneDrive"
$global:InstallTable | Select-Object -ExpandProperty InstallLocation @Logs

New-Test "Get-TypeName"
$global:InstallTable | Get-TypeName @Logs

Update-Log
Exit-Test
