
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

#
# Unit test for Test-Environment
#
. $PSScriptRoot\..\..\Config\ProjectSettings.ps1
New-Variable -Name ThisScript -Scope Private -Option Constant -Value (
	$MyInvocation.MyCommand.Name -replace ".{4}$" )

# Check requirements
Initialize-Project

# Imports
. $PSScriptRoot\ContextSetup.ps1
Import-Module -Name Project.AllPlatforms.Logging

# User prompt
Update-Context $TestContext $ThisScript @Logs
if (!(Approve-Execute @Logs)) { exit }

Enter-Test $ThisScript

$Result = "C:\"
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

$Result = "C:\\Windows\System32"
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

$Result = "C:\\Windows\"
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

$Result = "C:\Program Files (x86)\Windows Defender\"
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

$Result = "C:\Program Files\WindowsPowerShell"
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

$Result = '"C:\ProgramData\Git"'
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

$Result = "C:\PerfLogs"
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

$Result = "C:\Windows\Microsoft.NET\Framework64\v3.5\\"
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

$Result = "'C:\Windows\Microsoft.NET\Framework64\v3.5'"
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

$Result = "D:\\microsoft\\windows"
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

$Result = "D:\"
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

$Result = "C:\\"
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

$Result = "%LOCALAPPDATA%\OneDrive"
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

$Result = "%HOME%\AppData\Local\OneDrive"
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

$Result = "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer"
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

$Result = "%SystemDrive%"
Start-Test "Test-Environment: $Result"
$Status = Test-Environment $Result @Logs
$Status

$Result = ""
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

$Result = $null
Start-Test "Test-Environment: $Result"
Test-Environment $Result @Logs

Start-Test "Get-TypeName"
$Status | Get-TypeName @Logs

Update-Log
Exit-Test
