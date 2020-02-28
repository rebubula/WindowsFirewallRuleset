
#
# Module manifest for module 'Project.Windows.UserInfo'
#
# Generated by: metablaster
#
# Generated on: 11.2.2020.
#

@{

	# Script module or binary module file associated with this manifest.
	RootModule = 'Project.Windows.UserInfo.psm1'

	# Version number of this module.
	ModuleVersion = '0.3.0'

	# Supported PSEditions
	CompatiblePSEditions = 'Core, Desktop'

	# ID used to uniquely identify this module
	GUID = '136254f4-4730-4ed1-b9e9-1ccecfe09ee9'

	# Author of this module
	Author = 'metablaster zebal@protonmail.ch'

	# Company or vendor of this module
	# CompanyName = 'Unknown'

	# Copyright statement for this module
	Copyright = 'Copyright (C) 2019, 2020 metablaster'

	# Description of the functionality provided by this module
	Description = 'Query computer users and groups on Windows systems'

	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.1'

	# Name of the Windows PowerShell host required by this module
	PowerShellHostName = 'ConsoleHost'

	# Minimum version of the Windows PowerShell host required by this module
	# PowerShellHostVersion = ''

	# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
	DotNetFrameworkVersion = '3.5'

	# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
	CLRVersion = '2.0'

	# Processor architecture (None, X86, Amd64) required by this module
	ProcessorArchitecture = 'None'

	# Modules that must be imported into the global environment prior to importing this module
	# RequiredModules = @()

	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @()

	# Script files (.ps1) that are run in the caller's environment prior to importing this module.
	# ScriptsToProcess = @()

	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @()

	# Format files (.ps1xml) to be loaded when importing this module
	# FormatsToProcess = @()

	# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
	# NestedModules = @()

	# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
	FunctionsToExport = @(
		"ConvertFrom-UserAccount"
		"Get-AccountSID"
		"Get-GroupPrincipals"
		"Get-GroupSID"
		"Get-SDDL"
		"Merge-SDDL"
		"Get-UserGroups"
		"ConvertFrom-SID"
	)

	# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
	CmdletsToExport = @()

	# Variables to export from this module
	VariablesToExport = @(
		"CheckInitUserInfo"
		"UsersGroupSDDL"
		"AdministratorsGroupSDDL"
		"NT_AUTHORITY_System"
		"NT_AUTHORITY_LocalService"
		"NT_AUTHORITY_NetworkService"
		"NT_AUTHORITY_UserModeDrivers"
	)

	# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
	AliasesToExport = @()

	# DSC resources to export from this module
	# DscResourcesToExport = @()

	# List of all modules packaged with this module
	# ModuleList = @()

	# List of all files packaged with this module
	FileList = @(
		"Project.Windows.UserInfo.psd1"
		"Project.Windows.UserInfo.psm1"
		"about_Project.Windows.UserInfo.help.txt"
		"ConvertFrom-SID.ps1"
	)

	# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{

		PSData = @{

			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @("UserInfo", "ComputerUsers", "Users")

			# A URL to the license for this module.
			LicenseUri = 'https://github.com/metablaster/WindowsFirewallRuleset/blob/master/LICENSE'

			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/metablaster/WindowsFirewallRuleset'

			# A URL to an icon representing this module.
			# IconUri = ''

			# ReleaseNotes of this module
			ReleaseNotes = 'This pre-release is sufficiently stable to query users on Windows systems'
		} # End of PSData hashtable
	} # End of PrivateData hashtable

	# HelpInfo URI of this module
	HelpInfoURI = 'https://github.com/metablaster/WindowsFirewallRuleset/blob/master/README.md'

	# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
	# DefaultCommandPrefix = ''
}
